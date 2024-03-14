import Data.Text
import Distribution.Simple.Utils (copyDirectoryRecursive)
import Distribution.Verbosity (normal)
import System.Directory (renamePath)
import System.Environment (getArgs)
import Turtle

renameBak :: FilePath -> FilePath
renameBak filePath =
  let name = format fp filePath
   in if pack ".bak" `isSuffixOf` name
        then unpack $ dropEnd 4 name
        else unpack $ name <> pack ".bak"

processFile :: FilePath -> Bool -> IO ()
processFile filePath shouldCopy = do
  let newFilePath = renameBak filePath
  when shouldCopy $ do
    isDir <- testdir filePath
    if isDir
      then copyDirectoryRecursive normal filePath newFilePath -- Copy the directory
      else cp filePath newFilePath -- Copy the file
  unless shouldCopy $ renamePath filePath newFilePath -- Rename the original file only if not copying

main :: IO ()
main = do
  args <- getArgs
  case args of
    ("-c" : filePath : _) -> processFile filePath True
    (filePath : _) -> processFile filePath False
    _ -> putStrLn "Usage: bak [-c] <filepath>"

-- By using let name =, you are assigning the computed
-- value to the identifier name.
-- "format fp filePath" - function 'format' takes
-- a formatter 'fp', which stands for "file path",
-- and the 'filePath' value. The final result is a value
-- of a type 'Text'.
-- The reason for that is because the Text type is just
-- more robust for file paths, then 'String'
-- (the FilePath type is actually a String type).
-- "in if pack ".bak" `isSuffixOf` name":
-- ) pack is necessary because to make an assesment of the
-- suffix against the file path, they both should be the
-- same type.
-- the 'in' usage is a part of explicit scoping system
-- which represented as 'let... in...'.
-- 'dropEnd' drops the last 4 characters from 'name'.
-- 'unpack' converts Text type back to String.
-- <> is a concatenation symbol.
