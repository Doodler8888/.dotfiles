-- Function to replace a specific byte value with another character
-- Input: input_string, byte_value_to_find (decimal), replacement_char (string)
-- Output: the string with all occurrences of the byte replaced
function replace_byte_value(input_string, byte_to_find, replacement_char)
  if input_string == nil then
    return nil
  end

  local output_parts = {} -- Use a table to build the output string efficiently
  for i = 1, #input_string do
    local current_byte = string.byte(input_string, i)
    if current_byte == byte_to_find then
      -- If the byte IS the one we want to replace, add the replacement character
      table.insert(output_parts, replacement_char)
    else
      -- Otherwise, add the original character
      table.insert(output_parts, string.char(current_byte))
    end
  end

  -- Concatenate all the collected parts into the final string
  return table.concat(output_parts)
end

-- ==========================
-- Main Script Logic
-- ==========================

local input_filename = arg[1]
if not input_filename then
  io.stderr:write("Error: No input filename provided.\nUsage: lua your_script_name.lua <filename>\n")
  os.exit(1)
end

local file_iterator, err = io.lines(input_filename)
if not file_iterator then
  io.stderr:write("Error opening file '" .. input_filename .. "': " .. (err or "Unknown error") .. "\n")
  os.exit(1)
end

-- The decimal value for hex 1d (Group Separator) is 29
local gs_byte_decimal = 29
-- The character to replace it with is a space
local space_char = " "

for line in file_iterator do
  -- Process the line using the byte replacement function
  local cleaned_line = replace_byte_value(line, gs_byte_decimal, space_char)
  -- Print the cleaned line to standard output
  print(cleaned_line)
end
