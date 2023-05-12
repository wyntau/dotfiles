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

-- 设置 jk 快速进入normal模式
keymap('i', 'jk', '<Esc>')
keymap('i', 'kj', '<Esc>')

-- set wrap之后，将自动换行的长行当做多行处理, 方便在长行之间跳转.
keymap('n', 'k', 'gk')
keymap('n', 'j', 'gj')

-- remap U to <C-r> for easier redo
keymap('n', 'U', '<C-r>')

-- 插入模式, 使用ctrl-l跳出右括号
keymap('i', '<C-l>', '<Right>')
keymap('i', '<C-h>', '<Left>')
keymap('i', '<C-j>', '<Down>')
keymap('i', '<C-k>', '<Up>')
keymap('i', '<C-a>', '<Esc>_i')
keymap('i', '<C-e>', '<Esc>g_a')

-- Move across wrapped lines like regular lines
keymap('n', '0', '^') -- Go to the first non-blank character of a line
keymap('n', '^', '0') -- Just in case you need to go to the very beginning of a line