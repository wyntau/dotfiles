-- 插件管理器配置（使用 Packer）

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- vim.cmd([[packadd packer.nvim]])
require('packer').startup(function(use)
  -- use packer to manage itself
  use { 'wbthomason/packer.nvim' }

  use { "ellisonleao/gruvbox.nvim", config = function()
    vim.opt.background = "dark" -- or "light" for light mode
    vim.cmd('colorscheme gruvbox')
  end }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
