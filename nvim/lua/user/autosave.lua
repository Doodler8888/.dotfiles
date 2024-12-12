require("auto-save").setup({
    condition = function(buf)
        local fn = vim.fn

        local oil_filetype = "oil"
        local sql_filetype = "sql"

        -- Check for oil-ssh:// in buffer name
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if buf_name:match("^oil%-ssh://") then
            return false
        end

        -- If the buffer's filetype is oil_filetype, do not save
        if fn.getbufvar(buf, "&filetype") == oil_filetype or fn.getbufvar(buf, "&filetype") == sql_filetype then
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
            return ""
        end
    }
})
