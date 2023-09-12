return {
  -- cmd = {
  --   "clangd",
  --   "--background-index",
  --   "--clang-tidy",
  --   "--suggest-missing-includes",
  --   "--completion-style=bundled",
  --   "--cross-file-rename",
  --   "--header-insertion=iwyu",
  -- },
  -- init_options = {
  --   usePlaceholders = true,
  --   completeUnimported = true,
  --   clangdFileStatus = true
  -- },
  -- flags = { debounce_text_changes = 150 }
  cmd = {"clangd", "--background-index"},
    single_file_support = true,
    root_dir = lspconfig.util.root_pattern(
          '.clangd',
          '.clang-tidy',
          '.clang-format',
          'compile_commands.json',
          'compile_flags.txt',
          'configure.ac',
          '.git'
        )
}
