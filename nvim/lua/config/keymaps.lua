local keymap = vim.keymap;

--#region 设置 jk 快速进入normal模式
keymap.set('i', 'jk', '<Esc>')
keymap.set('i', 'kj', '<Esc>')
--#endregion

--#region Move the cursor based on physical lines, not the actual lines.
keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
keymap.set("n", "^", "g^")
keymap.set("n", "0", "g0")
--#endregion

keymap.set('n', 'U', '<C-r>', { desc = 'remap U to <C-r> for easier redo' })

keymap.set('n', '<leader>x16', '<ESC>:%!xxd<CR>', { desc = '十六进制格式查看'})
keymap.set('n', '<leader>xx16', '<ESC>:%!xxd -r<CR>', { desc = '返回普通格式'})

--#region 插入模式光标跳转
keymap.set('i', '<C-l>', '<Right>')
keymap.set('i', '<C-h>', '<Left>')
keymap.set('i', '<C-j>', '<Down>')
keymap.set('i', '<C-k>', '<Up>')
keymap.set('i', '<C-a>', '<Esc>_i')
keymap.set('i', '<C-e>', '<Esc>g_a')
--#endregion

keymap.set('n', 'Y', 'y$', { desc = '使用Y, 类似于D删除到行尾' })

-- search
keymap.set('n', '#', '*', { silent = true })
keymap.set('n', '*', '#', { silent = true })
keymap.set('n', 'g*', 'g#', { silent = true })
keymap.set('n', 'g#', 'g*', { silent = true })

-- visual mode
keymap.set('v', '*', [[y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>]], { desc = '全文搜索选中的文字' })
keymap.set('v', '#', [[y?<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>]], { desc = '全文搜索选中的文字' })

--#region
-- Continuous visual shifting (does not exit Visual mode), `gv` means
-- to reselect previous visual area, see https://superuser.com/q/310417/736190
keymap.set('v', '>', '>gv')
keymap.set('v', '<', '<gv')
keymap.set('v', '<Tab>', '>gv')
keymap.set('v', '<S-Tab>', '<gv')
--#endregion

--#region buffer
keymap.set('n', '<leader>bs', ':enew<CR>')
keymap.set('n', '<leader>bn', ':bnext<CR>')
keymap.set('n', '<leader>bb', ':bnext<CR>')
keymap.set('n', '<leader>bp', ':bprevious<CR>')
keymap.set('n', '<leader>bl', ':ls<CR>')
keymap.set('n', '<leader>bd', ':bd<CR>')
keymap.set('n', '<leader>bk', ':bd<CR>')
--#endregion
