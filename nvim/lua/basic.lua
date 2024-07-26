-- 设置leader键为逗号
vim.g.mapleader = ','

vim.opt.fileencodings = 'utf-8,gb2312,gbk,gb18030,ucs-bom,cp936,big5,euc-jp,euc-kr,latin1'
vim.opt.fileformats = 'unix,dos,mac'

-- 显示行号
vim.opt.number = true
-- 启用相对行号
vim.opt.relativenumber = true
--  插入模式下用绝对行号, 普通模式下用相对
vim.api.nvim_create_autocmd({'FocusLost', 'InsertEnter'}, { command = ':set norelativenumber' })
vim.api.nvim_create_autocmd({'FocusGained', 'InsertLeave'}, { command = ':set relativenumber' })
vim.opt.colorcolumn = '80,100'

-- 使用空格代替制表符
vim.opt.expandtab = true
-- 设置制表符宽度为2个空格
vim.opt.tabstop = 2
-- 使得按退格键时可以一次删掉 2 个空格
vim.opt.softtabstop = 2
-- 用<>调整缩进时的长度缩进2格
vim.opt.shiftwidth = 2

-- 设置自动缩进
vim.opt.autoindent = true
vim.opt.smartindent = true

-- 启用鼠标支持
vim.opt.mouse = 'a'
-- 允许使用鼠标选择文本
vim.opt.selection = 'inclusive'

-- 高亮当前行
vim.opt.cursorline = true;

-- 高亮搜索结果
vim.opt.hlsearch = true
-- 忽略大小写进行搜索
vim.opt.ignorecase = true
-- 启用增量搜索
vim.opt.incsearch = true
-- 有一个或以上大写字母时仍大小写敏感
vim.opt.smartcase = true
-- 禁止在搜索到文件两端时重新搜索
vim.opt.wrapscan = false
-- 在搜索时实时显示匹配的结果
vim.opt.inccommand = 'nosplit'
-- 显示当前匹配项的搜索结果数量
vim.opt.showmatch = true
-- 去掉搜索高亮
vim.keymap.set('n', '<leader>sc', ':nohlsearch<CR>')

-- 启用折叠
vim.opt.foldenable = false
-- 设置折叠方法为基于缩进的折叠
vim.opt.foldmethod = 'indent'

-- 设置状态栏
vim.opt.statusline = '%<%f %h%m%r%=%-14.(%l,%c%V%)%P'

-- 在处理未保存或只读文件的时候，弹出确认
vim.opt.confirm = true
vim.opt.swapfile = false

-- 竖直split时,在右边开启
vim.opt.splitright = true
-- 水平split时,在下边开启
vim.opt.splitbelow = true

-- Open help in a vertical split instead of the default horizontal split
vim.cmd([[
  cabbrev h <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'vert h' : 'h')<cr>
  cabbrev help <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'vert h' : 'help')<cr>
]])