-- 插件管理器配置 (使用 lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 9999,
    config = function()
      vim.opt.background = "dark" -- or "light" for light mode
      vim.cmd('colorscheme gruvbox')
    end
  },
}, {})