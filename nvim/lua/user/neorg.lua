require("neorg").setup {
  load = {
    ["core.defaults"] = {}, -- Loads default behaviour
    ["core.completion"] = {
      config = {
        engine = "nvim-cmp", -- Specify the completion engine
      },
    },
    ["core.concealer"] = {}, -- Adds pretty icons to your documents
    ["core.dirman"] = { -- Manages Neorg workspaces
      config = {
	workspaces = {
	  notes = "~/.secret_dotfiles/notes",
	},
      },
    },
  },
}


-- Function to create a new .norg file in the notes workspace
function _G.create_norg_file()
 -- Prompt the user for a file name
 local file_name = vim.fn.input("Enter file name: ")

 -- Check if the user entered a file name
 if file_name == "" then
    print("No file name provided.")
    return
 end

 -- Append '.norg' to the file name
 local full_file_name = file_name .. ".norg"

 -- Define the path to the notes workspace
 local workspace_path = "~/.secret_dotfiles/notes"

 -- Construct the full path to the new file
 local full_path = workspace_path .. "/" .. full_file_name

 -- Create the new file and open a buffer on it
 vim.cmd("edit " .. full_path)
end

-- Map a key to call the function (optional)
vim.api.nvim_set_keymap('n', '<leader>nn', ':lua create_norg_file()<CR>', {noremap = true, silent = true})
