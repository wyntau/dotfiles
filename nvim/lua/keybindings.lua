--mappings
local function keymap(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- 定义快捷键映射
keymap('n', '<leader>w', ':w<CR>')
keymap('n', '<leader>q', ':q<CR>')
keymap('n', '<leader>r', ':w<CR>:source %<CR>')

keymap('i', 'jk', '<Esc>')
keymap('i', 'kj', '<Esc>')
