--------------------------
-- TREESITTER
--------------------------

return {
	'nvim-treesitter/nvim-treesitter',
	dependencies = {
		'nvim-treesitter/nvim-treesitter-textobjects',
	},
	config = function()
		pcall(require('nvim-treesitter.install').update { with_sync = true })
		require('nvim-treesitter.install').compilers = { "clang" }
		require('nvim-treesitter.configs').setup {
			ensure_installed = {
				"bash",
                "diff",
                "gitcommit",
                "go",
                "hcl",
				-- "help",
                "markdown",
				"json",
                "json5",
				"lua",
				"python",
                "rust",
                "yaml",
			},
			sync_install = false,
			auto_install = false,
			highlight = {
				enable = true,
				disable = { "css" },
				additional_vim_regex_highlighting = false,
			},
			autopairs = {
				enable = true,
			},
			indent = {
				enable = true,
				disable = { "python", "css" },
			},
		}
	end
}
