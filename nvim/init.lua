require('utils');

-- 设置leader键为逗号
vim.g.mapleader = ','

-- 显示行号
vim.opt.number = true

-- 启用相对行号
vim.opt.relativenumber = true

-- 使用空格代替制表符
vim.opt.expandtab = true

-- 设置制表符宽度为4个空格
vim.opt.tabstop = 4

-- 设置自动缩进
vim.opt.autoindent = true

-- 启用鼠标支持
vim.opt.mouse = 'a'

-- 允许使用鼠标选择文本
vim.opt.selection = 'inclusive'

-- 高亮搜索结果
vim.opt.hlsearch = true

-- 忽略大小写进行搜索
vim.opt.ignorecase = true

-- 启用增量搜索
vim.opt.incsearch = true

-- 在搜索时实时显示匹配的结果
vim.opt.inccommand = 'nosplit'

-- 显示当前匹配项的搜索结果数量
vim.opt.showmatch = true

-- 启用折叠
vim.opt.foldenable = true

-- 设置折叠方法为基于缩进的折叠
vim.opt.foldmethod = 'indent'

-- 设置状态栏
vim.opt.statusline = '%<%f %h%m%r%=%-14.(%l,%c%V%)%P'

-- 定义快捷键映射
vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', ':q<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>r', ':w<CR>:source %<CR>', { noremap = true, silent = true })

-- 自动重新加载 init.lua 文件
vim.cmd('autocmd! BufWritePost init.lua source %')

-- 静默设置配色方案
vim.cmd('silent! colorscheme gruvbox')

require('plugins')
