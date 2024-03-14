import Control.Exception (try)
import Data.Text (Text)
import Data.Time (Day)
import System.Process (readProcess)
import Toml

data Settings = Settings
  { settingsPort :: !Int
  , settingsDescription :: !Text
  , settingsCodes :: ![Int]
  , settingsMail :: !Mail
  , settingsUsers :: ![User]
  }

data Mail = Mail 
  { mailHost :: !Text
  , mailSendIfInactive :: !Bool
  }

data User 
  = Guest !Int
  | Registered !RegisteredUser

data RegisteredUser = RegisteredUser
  { registeredUserLogin :: !Text
  , registeredUserCreatedAt :: !Day
  }

settingsCodec :: TomlCodec Settings
settingsCodec = Settings
  <$> Toml.int "server.port" .= settingsPort
  <*> Toml.text "server.description" .= settingsDescription
  <*> Toml.arrayOf Toml.int "server.codes" .= settingsCodes
  <*> Toml.table mailCodec "mail" .= settingsMail
  <*> Toml.list userCodec "user" .= settingsUsers

-- Other codecs...

getLatestVersion :: Text -> IO (Maybe Text)
getLatestVersion lib = do
  result <- try $ readProcess "cargo" ["search", lib] ""
  case result of
    Left _ -> return Nothing
    Right output -> do
      let match = head . filter (isInfixOf "\"") $ lines output
      return $ fmap tail match

updateLibraryVersions :: Text -> IO ()  
updateLibraryVersions filename = do

  contents <- readFile filename

  case decode contents of
    Left err -> putStrLn $ "Decoding error: " ++ show err
    Right data -> do
    
      let dependencies = data ^. key "dependencies" . _Object

      forM_ (HashMap.toList dependencies) $ \(lib, version) -> do

        mNewVersion <- getLatestVersion lib
        
        case mNewVersion of
          Just newVersion
            | newVersion /= version -> do
                putStrLn $ "Updating " ++ lib ++ ": " ++ show version ++ " -> " ++ newVersion
                data & key "dependencies" . ix lib .~ newVersion
        
          _ -> putStrLn $ "No update or not found: " ++ lib
      
      writeFile filename $ encode data

main :: IO ()
main = do
  args <- getArgs
  case args of
    [filename] -> updateLibraryVersions filename
    _ -> putStrLn "Usage: runhaskell script.hs <filename>"
