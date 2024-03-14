require('boole').setup({
  mappings = {
    increment = '<C-a>',
    decrement = '<C-x>'
  },
  -- User defined loops
  additions = {
    {'Foo', 'Bar'},
    {'True', 'False'},
    {'tic', 'tac', 'toe'}
  },
  allow_caps_additions = {
    {'enable', 'disable'},
    -- enable → disable
    -- Enable → Disable
    -- ENABLE → DISABLE

    -- { 'true', 'false'}, -- This is my addition
  }
})



