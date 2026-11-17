-- ~/.config/nvim/colors/middle-earth.lua
-- Reads the current place's kitty theme (~/.config/kitty/current-theme.conf),
-- so Neovim matches Bag End, Bree, Rivendell, Moria or Lórien.
local path = vim.fn.expand("~/.config/kitty/current-theme.conf")
local c = {}
local f = io.open(path, "r")
if f then
  for line in f:lines() do
    local k, v = line:match("^(%S+)%s+(#%x%x%x%x%x%x)")
    if k then c[k] = v end
  end
  f:close()
end
-- fallback: the Shire
local d = { background="#1e2219", foreground="#e8dcc0", color0="#2b3024", color8="#4a5240",
  color1="#c0634f", color2="#8fa86b", color3="#d9a24e", color4="#7a9bad", color5="#a87a8f",
  color6="#7aa89a", color9="#d67a64", color10="#a8c084", color11="#e0c36a", color12="#94b4c4",
  color13="#c094a8", color14="#94c0b2", color7="#e8dcc0", color15="#f5ecd6" }
setmetatable(c, { __index = d })

vim.cmd("highlight clear")
vim.o.background = "dark"
vim.g.colors_name = "middle-earth"

local bg, fg, surface, muted = c.background, c.foreground, c.color0, c.color8
local red, green, gold, blue, mag, cyan = c.color1, c.color2, c.color3, c.color4, c.color5, c.color6
local bright_gold, bright_green = c.color11, c.color10

local hl = function(g, o) vim.api.nvim_set_hl(0, g, o) end
local groups = {
  Normal = { fg = fg, bg = bg },            NormalFloat = { fg = fg, bg = surface },
  FloatBorder = { fg = gold, bg = surface }, Cursor = { fg = bg, bg = bright_gold },
  CursorLine = { bg = surface },            CursorLineNr = { fg = bright_gold, bold = true },
  LineNr = { fg = muted },                  SignColumn = { bg = bg },
  ColorColumn = { bg = surface },           VertSplit = { fg = surface },
  WinSeparator = { fg = surface },          Visual = { bg = muted },
  Search = { fg = bg, bg = gold },          IncSearch = { fg = bg, bg = bright_gold },
  CurSearch = { fg = bg, bg = bright_gold },MatchParen = { fg = bright_gold, bold = true, underline = true },
  Pmenu = { fg = fg, bg = surface },        PmenuSel = { fg = bg, bg = green },
  PmenuThumb = { bg = gold },               StatusLine = { fg = fg, bg = surface },
  StatusLineNC = { fg = muted, bg = bg },   TabLine = { fg = muted, bg = surface },
  TabLineSel = { fg = bg, bg = green },     TabLineFill = { bg = bg },
  Folded = { fg = muted, bg = surface },    NonText = { fg = muted },
  Whitespace = { fg = surface },            EndOfBuffer = { fg = bg },
  Title = { fg = gold, bold = true },       Directory = { fg = blue },
  ErrorMsg = { fg = red, bold = true },     WarningMsg = { fg = gold },
  MoreMsg = { fg = green },                 Question = { fg = green },

  Comment = { fg = muted, italic = true },  Constant = { fg = mag },
  String = { fg = green },                  Character = { fg = green },
  Number = { fg = mag },                    Boolean = { fg = mag },
  Identifier = { fg = fg },                 Function = { fg = blue },
  Statement = { fg = gold },                Keyword = { fg = gold, italic = true },
  Conditional = { fg = gold },              Repeat = { fg = gold },
  Operator = { fg = cyan },                 PreProc = { fg = cyan },
  Type = { fg = bright_gold },              Special = { fg = cyan },
  Delimiter = { fg = muted },               Todo = { fg = bg, bg = gold, bold = true },
  Error = { fg = red },                     Underlined = { fg = blue, underline = true },

  DiagnosticError = { fg = red },           DiagnosticWarn = { fg = gold },
  DiagnosticInfo = { fg = blue },           DiagnosticHint = { fg = cyan },
  DiagnosticUnderlineError = { sp = red, undercurl = true },
  DiagnosticUnderlineWarn = { sp = gold, undercurl = true },
  DiffAdd = { fg = green },                 DiffChange = { fg = gold },
  DiffDelete = { fg = red },                DiffText = { fg = bg, bg = gold },
  Added = { fg = green },                   Changed = { fg = gold },
  Removed = { fg = red },

  ["@variable"] = { fg = fg },              ["@variable.builtin"] = { fg = red, italic = true },
  ["@variable.parameter"] = { fg = c.color15 },["@property"] = { fg = cyan },
  ["@function.builtin"] = { fg = blue, italic = true },
  ["@constructor"] = { fg = bright_gold },  ["@keyword.return"] = { fg = red, italic = true },
  ["@punctuation.bracket"] = { fg = muted },["@tag"] = { fg = gold },
  ["@tag.attribute"] = { fg = cyan },       ["@markup.heading"] = { fg = gold, bold = true },
  ["@markup.link"] = { fg = blue, underline = true },
}
for g, o in pairs(groups) do hl(g, o) end
for i = 0, 15 do vim.g["terminal_color_" .. i] = c["color" .. i] end
