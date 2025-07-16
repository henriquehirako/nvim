vim.cmd [[
  let g:ale_linter_aliases = {
  \ 'smarty': ['yaml']
  \ }
]]
vim.cmd [[let g:ale_completion_enabled = 0]]
vim.cmd [[let g:ale_emit_conflict_warnings = 0]]
vim.cmd [[let g:ale_use_neovim_diagnostics_api = 1]]
vim.cmd [[
  let g:ale_fixers = {
  \   'javascript': ['eslint'],
  \   'typescript': ['eslint'],
  \   'scss': ['stylelint'],
  \   'css': ['stylelint'],
  \   'go': ['gofmt'],
  \   'solidity': ['solium'],
  \   'ruby': ['rubocop'],
  \   'sql': ['pgformatter'],
  \}
]]
vim.cmd [[
  let g:ale_linters = {
  \   'javascript': ['eslint'],
  \   'typescript': ['eslint'],
  \   'scss': ['stylelint'],
  \   'css': ['stylelint'],
  \   'go': ['gofmt'],
  \   'solidity': ['solium'],
  \   'php': ['php'],
  \   'ruby': ['rails_best_practices', 'rubocop', 'reek'],
  \   'yaml': ['yamllint'],
  \   'yml': ['yamllint']
  \}
]]

--  Uncomment to run eslint_d global. Otherwise it will search on node_modules
vim.cmd [[let g:ale_javascript_eslint_use_global = 1]]
-- " let g:ale_javascript_eslint_executable = 'eslint_d'
vim.cmd [[let g:ale_fix_on_save = 0]]
vim.cmd [[let g:ale_lint_on_text_changed = 'never']]
vim.cmd [[let g:ale_cache_executable_check_failures = 1]]
vim.cmd [[let g:ale_ruby_rails_best_practices_executable = 'bundle']]
vim.cmd [[let g:ale_ruby_reek_executable = 'bundle']]
vim.cmd [[let g:ale_ruby_rubocop_executable = 'bundle']]
vim.cmd [[let g:airline#extensions#ale#enabled = 1]]

vim.cmd [[let g:ale_lint_on_insert_leave = 0]]
-- " if you don't want linters to run on opening a file
vim.cmd [[let g:ale_lint_on_enter = 1]]
vim.cmd [[lef g:ale_lint_on_save = 1]]

vim.cmd [[let g:ale_echo_msg_format = '[%linter%] %code% - %s [%severity%]']]
vim.cmd [[let g:ale_sign_error = '✘']]
vim.cmd [[let g:ale_sign_warning = '⚠']]
