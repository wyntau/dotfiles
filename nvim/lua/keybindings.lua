--mappings
-- 定义快捷键映射
vim.keymap.set('n', '<leader>w', ':w<CR>')
vim.keymap.set('n', '<leader>q', ':q<CR>')
vim.keymap.set('n', '<leader>r', ':w<CR>:source %<CR>')

-- 设置 jk 快速进入normal模式
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('i', 'kj', '<Esc>')

vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = 'set wrap之后，将自动换行的长行当做多行处理, 方便在长行之间跳转' })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = 'set wrap之后，将自动换行的长行当做多行处理, 方便在长行之间跳转' })
vim.keymap.set("n", "^", "g^")
vim.keymap.set("n", "0", "g0")

vim.keymap.set('n', 'U', '<C-r>', { desc = 'remap U to <C-r> for easier redo' })

vim.keymap.set('n', '<leader>x16', '<ESC>:%!xxd<CR>', { desc = '十六进制格式查看'})
vim.keymap.set('n', '<leader>xx16', '<ESC>:%!xxd -r<CR>', { desc = '返回普通格式'})

-- 插入模式, 使用ctrl-l跳出右括号
vim.keymap.set('i', '<C-l>', '<Right>')
vim.keymap.set('i', '<C-h>', '<Left>')
vim.keymap.set('i', '<C-j>', '<Down>')
vim.keymap.set('i', '<C-k>', '<Up>')
vim.keymap.set('i', '<C-a>', '<Esc>_i')
vim.keymap.set('i', '<C-e>', '<Esc>g_a')

vim.keymap.set('n', 'Y', 'y$', { desc = '使用Y, 类似于D删除到行尾' })

-- search
vim.keymap.set('n', '#', '*', { silent = true })
vim.keymap.set('n', '*', '#', { silent = true })
vim.keymap.set('n', 'g*', 'g#', { silent = true })
vim.keymap.set('n', 'g#', 'g*', { silent = true })

-- visual mode
vim.keymap.set('v', '*', [[y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>]], { desc = '全文搜索选中的文字' })
vim.keymap.set('v', '#', [[y?<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>]], { desc = '全文搜索选中的文字' })
vim.keymap.set('v', '>', '>gv', { desc = '调整缩进后自动选中，方便再次操作' })
vim.keymap.set('v', '<', '<gv', { desc = '调整缩进后自动选中，方便再次操作' })
vim.keymap.set('v', '<Tab>', '>gv')
vim.keymap.set('v', '<S-Tab>', '<gv')

-- buffer
vim.keymap.set('n', '<leader>bs', ':enew<CR>')
vim.keymap.set('n', '<leader>bn', ':bnext<CR>')
vim.keymap.set('n', '<leader>bb', ':bnext<CR>')
vim.keymap.set('n', '<leader>bp', ':bprevious<CR>')
vim.keymap.set('n', '<leader>bl', ':ls<CR>')
vim.keymap.set('n', '<leader>bd', ':bd<CR>')
vim.keymap.set('n', '<leader>bk', ':bd<CR>')
