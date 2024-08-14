return {
  "ellisonleao/gruvbox.nvim",
  lazy = false,
  priority = 9999,
  config = function()
    vim.opt.background = "dark" -- or "light" for light mode
    vim.cmd('colorscheme gruvbox')
  end
}
