return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({

				base00 = '#24273a',
				base01 = '#1e2030',
				base02 = '#24273a',
				base03 = '#99939f',
				base0B = '#ffdb72',
				base04 = '#f6efff',
				base05 = '#fbf8ff',
				base06 = '#fbf8ff',
				base07 = '#fbf8ff',
				base08 = '#ff9fb1',
				base09 = '#ff9fb1',
				base0A = '#d4b3ff',
				base0C = '#e8d6ff',
				base0D = '#d4b3ff',
				base0E = '#dcc0ff',
				base0F = '#dcc0ff',
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
