return {
	{
		"hrsh7th/nvim-cmp",
		config = function(_, opts)
			local cmp = require("cmp")

			cmp.setup({
				sources = {
					{ name = "nvim_lsp", group_index = 1 },
					{ name = "copilot", group_index = 2 },
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
				performance = {
					max_view_entries = 15,
				},
			})
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("cmp_nvim_lsp").default_capabilities()
			--
			-- LspAttach is where you enable features that only work
			-- if there is a language server active in the file
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf }

					vim.keymap.set({ "n", "v" }, "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
					vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
					vim.keymap.set("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
					vim.keymap.set(
						"n",
						"<space>f",
						'<cmd>lua vim.lsp.buf.format({async = true, filter = function(client) return client.name ~= "ts_ls" end})<cr>',
						opts
					)
					vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.jump({count=1, float=true})<cr>", opts)
					vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.jump({count=-1, float=true})<cr>", opts)
					vim.keymap.set("n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
					vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
				end,
			})

			-- Format on save
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = buffer,
				callback = function()
					vim.lsp.buf.format({
						async = false,
						filter = function(client)
							return client.name ~= "ts_ls"
						end,
					})
				end,
			})

			require("mason-lspconfig").setup({
				ensure_installed = {
					"ts_ls",
					"eslint@4.8.0",
					"lua_ls",
					"stylua",
					"jsonls",
					"biome",
					"gopls",
					"oxlint",
					"oxfmt",
				},
			})

			vim.lsp.config("biome", {
				root_dir = function(bufnr, on_dir)
					local fname = vim.api.nvim_buf_get_name(bufnr)
					local biome_config = vim.fs.find({ "biome.json", "biome.jsonc" }, {
						path = fname,
						upward = true,
						type = "file",
					})[1]
					if biome_config then
						on_dir(vim.fs.dirname(biome_config))
					end
				end,
			})

			vim.lsp.config("oxfmt", {
				root_dir = function(bufnr, on_dir)
					local fname = vim.api.nvim_buf_get_name(bufnr)
					local oxfmt_config = vim.fs.find({ ".oxfmtrc.json" }, {
						path = fname,
						upward = true,
						type = "file",
					})[1]
					if oxfmt_config then
						on_dir(vim.fs.dirname(oxfmt_config))
					end
				end,
			})

			vim.lsp.config("lua_ls", {
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if
							path ~= vim.fn.stdpath("config")
							and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
						then
							return
						end
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							-- Tell the language server which version of Lua you're using (most
							-- likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
							-- Tell the language server how to find Lua modules same way as Neovim
							-- (see `:h lua-module-load`)
							path = {
								"lua/?.lua",
								"lua/?/init.lua",
							},
						},
						-- Make the server aware of Neovim runtime files
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
								-- Depending on the usage, you might want to add additional paths
								-- here.
								-- '${3rd}/luv/library',
								-- '${3rd}/busted/library',
							},
							-- Or pull in all of 'runtimepath'.
							-- NOTE: this is a lot slower and will cause issues when working on
							-- your own configuration.
							-- See https://github.com/neovim/nvim-lspconfig/issues/3189
							-- library = vim.api.nvim_get_runtime_file('', true),
						},
					})
				end,
				settings = {
					Lua = {},
				},
			})
		end,
	},
}
