-- local status_ok, lualine = pcall(require, "lualine")
-- if not status_ok then
-- 	return
-- end
--
-- local hide_in_width = function()
-- 	return vim.fn.winwidth(0) > 80
-- end
--
-- local diagnostics = {
-- 	"diagnostics",
-- 	sources = { "nvim_diagnostic" },
-- 	sections = { "error", "warn" },
-- 	symbols = { error = " ", warn = " " },
-- 	colored = false,
-- 	update_in_insert = false,
-- 	always_visible = true,
-- }
--
-- local diff = {
-- 	"diff",
-- 	colored = false,
-- 	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
--   cond = hide_in_width
-- }
--
-- local mode = {
-- 	"mode",
-- 	fmt = function(str)
-- 		return "-- " .. str .. " --"
-- 	end,
-- }
--
-- local filetype = {
-- 	"filetype",
-- 	icons_enabled = false,
-- 	icon = nil,
-- }
--
-- local branch = {
-- 	"branch",
-- 	icons_enabled = true,
-- 	icon = "",
-- }
--
-- local location = {
-- 	"location",
-- 	padding = 0,
-- }
--
-- -- cool function for progress
-- local progress = function()
-- 	local current_line = vim.fn.line(".")
-- 	local total_lines = vim.fn.line("$")
-- 	local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
-- 	local line_ratio = current_line / total_lines
-- 	local index = math.ceil(line_ratio * #chars)
-- 	return chars[index]
-- end
--
-- local spaces = function()
-- 	return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
-- end
--
-- lualine.setup({
-- 	options = {
-- 		icons_enabled = true,
-- 		theme = "auto",
-- 		component_separators = { left = "", right = "" },
-- 		section_separators = { left = "", right = "" },
		-- disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
-- 		always_divide_middle = true,
-- 	},
-- 	sections = {
-- 		lualine_a = { branch, diagnostics },
-- 		lualine_b = { mode },
-- 		lualine_c = {},
-- 		-- lualine_x = { "encoding", "fileformat", "filetype" },
-- 		lualine_x = { diff, spaces, "encoding", filetype },
-- 		lualine_y = { location },
-- 		lualine_z = { progress },
-- 	},
-- 	inactive_sections = {
-- 		lualine_a = {},
-- 		lualine_b = {},
-- 		lualine_c = { "filename" },
-- 		lualine_x = { "location" },
-- 		lualine_y = {},
-- 		lualine_z = {},
-- 	},
-- 	tabline = {},
-- 	extensions = {},
-- })

-- stylua: ignore
local colors = {
  blue   = '#80a0ff',
  cyan   = '#79dac8',
  black  = '#080808',
  white  = '#c6c6c6',
  red    = '#ff5189',
  violet = '#d183e8',
  grey   = '#303030',
}

local diagnostics = {
  "diagnostics",
  source = {"nvim_diagnostic"},
  sections = {"error", "warn"},
  colored = true,
	symbols = { error = " ", warn = " " },
  always_visible = true
}

local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.violet },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.black, bg = colors.black },
  },

  insert = { a = { fg = colors.black, bg = colors.blue } },
  visual = { a = { fg = colors.black, bg = colors.cyan } },
  replace = { a = { fg = colors.black, bg = colors.red } },

  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.black, bg = colors.black },
  },
}

-- local inactivateFiletype = {"dapui_watches", "dapui_breakpoints",
--       "dapui_scopes", "dapui_console",
--       "dapui_stacks", "dap-repl"}
--
-- function fileTypeFilter (t, val)
-- 	for _, v in ipairs(t) do
-- 		if v == val then
-- 			return true
-- 		end
-- 	end
-- 	return false
-- end
--
--   
-- local sections = function()
--   if not fileTypeFilter(inactivateFiletype, string.gsub(vim.api.nvim_buf_get_name(0), vim.loop.cwd(), '')) then
--     return  {
--       lualine_a = {
--             { 'mode', separator = { left = '' }, right_padding = 2 },
--           },
--       lualine_b = { 'filename', diagnostics, 'branch'},
--       lualine_c = { 'fileformat' },
--       lualine_x = {},
--       lualine_y = { 'filetype', 'progress' },
--       lualine_z = {
--         { 'location', separator = { right = '' }, left_padding = 2 },
--       }
--     }
--   end
--   return {
--     lualine_a = {
--       { 'mode', separator = { left = '' }, right_padding = 2 },
--     },
--     lualine_b = { 'filename', separator = {right=''},left_padding=2},
--     lualine_c = { '' },
--     lualine_x = {},
--     lualine_y = { '', '' },
--     lualine_z = {}
--   }
-- end
--
require('lualine').setup {
  options = {
    theme = bubbles_theme,
    component_separators = ' ',
    -- section_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
		disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
  },
  sections = {
    lualine_a = {
      -- { 'mode', separator = { left = '' }, right_padding = 2 },

      { 'mode', separator = { left = '' }, right_padding = 2 },
    },
    lualine_b = { 'filename', diagnostics, 'branch'},
    lualine_c = { 'fileformat' },
    lualine_x = {},
    lualine_y = { 'filetype', 'progress' },
    lualine_z = {
      -- { 'location', separator = { right = '' }, left_padding = 2 },
      { 'location', separator = { right = '' }, left_padding = 2 },
    },
  },
  -- sections = sections(),
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  tabline = {},
  extensions = {
     {
      filetypes = {"dapui_watches", "dapui_breakpoints",
      "dapui_scopes", "dapui_console",
      "dapui_stacks", "dap-repl"},
      sections = {
       lualine_a = {
          -- { 'mode', separator = { left = '' }, right_padding = 2 },
          { 'mode', separator = { left = '' }, right_padding = 2 },
        },
        -- lualine_b = { 'filename', separator = {right=''},left_padding=2},
        lualine_b = {'filename'},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
      },
      inactive_sections = {
        lualine_a = { 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'location' },
      },

      options = {
        theme = bubbles_theme,
        component_separators = ' ',
        -- section_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
    },
  },
}
