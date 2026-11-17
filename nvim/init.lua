-- ~/.config/nvim/init.lua — small, sensible defaults + the Middle-earth colours
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.signcolumn = "yes"
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.scrolloff = 6
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.undofile = true

vim.cmd.colorscheme("middle-earth")

-- follow the place: recolour when you travel to another Hyprland workspace
local kitty_dir = vim.fn.expand("~/.config/kitty")
local watcher = vim.uv.new_fs_event()
if watcher then
  watcher:start(kitty_dir, {}, vim.schedule_wrap(function(_, fname)
    if fname == "current-theme.conf" then vim.cmd.colorscheme("middle-earth") end
  end))
end
vim.api.nvim_create_autocmd("FocusGained", {
  callback = function() vim.cmd.colorscheme("middle-earth") end,
})
