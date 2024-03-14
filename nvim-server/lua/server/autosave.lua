require("auto-save").setup({

    condition = function(buf)
        local fn = vim.fn

        -- Add the filetype of oil.nvim buffers here
        local oil_filetype = "oil"

        -- If the buffer's filetype is oil_filetype, do not save
        if fn.getbufvar(buf, "&filetype") == oil_filetype then
            return false
        end

        -- Your existing condition logic can remain here if there's more
        if fn.getbufvar(buf, "&modifiable") == 1 then
            return true
        end

        return false
    end,

    execution_message = {
			message = function()
				-- return an empty string
				return ""
			end
		}
		-- rest of your config goes here
	 })
