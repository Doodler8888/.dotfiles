require("user")



local function test_whitespace()    
    -- Extra spaces at end of this line    
    local x = 5     
    
    -- Multiple empty lines with spaces


    -- Tabs and spaces mixed
	local y = 10   	  
    
    -- Trailing whitespace in comments    # 
    
    -- Mixed indentation
    if x > 0 then    
    	print("test")     
        return true   
    end     
    
    -- Space before parentheses   
    function bad_spaces ()    
        print ("hello")    
    end     
end    

-- Empty line with spaces below
     
-- More trailing whitespace here    
local z = 15    
