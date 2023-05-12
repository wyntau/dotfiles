--mappings
-- 定义快捷键映射
vim.keymap.set('n', '<leader>w', ':w<CR>')
vim.keymap.set('n', '<leader>q', ':q<CR>')
vim.keymap.set('n', '<leader>r', ':w<CR>:source %<CR>')

-- 设置 jk 快速进入normal模式
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('i', 'kj', '<Esc>')

-- set wrap之后，将自动换行的长行当做多行处理, 方便在长行之间跳转.
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', 'j', 'gj')

-- remap U to <C-r> for easier redo
vim.keymap.set('n', 'U', '<C-r>')

-- 插入模式, 使用ctrl-l跳出右括号
vim.keymap.set('i', '<C-l>', '<Right>')
vim.keymap.set('i', '<C-h>', '<Left>')
vim.keymap.set('i', '<C-j>', '<Down>')
vim.keymap.set('i', '<C-k>', '<Up>')
vim.keymap.set('i', '<C-a>', '<Esc>_i')
vim.keymap.set('i', '<C-e>', '<Esc>g_a')

-- Move across wrapped lines like regular lines
vim.keymap.set('n', '0', '^') -- Go to the first non-blank character of a line
vim.keymap.set('n', '^', '0') -- Just in case you need to go to the very beginning of a line