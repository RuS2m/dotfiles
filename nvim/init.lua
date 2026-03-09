require("plugins") -- load plugins configuration
require("setup") -- load setup
require("tab") -- load custom tab configuration

--------------------------------------------------------

-- commands:
-- -----------------------------------------------------
--
-- lsp:
-- =====================
-- gd                                                   go to definition (opens in new window)
-- gr                                                   go to reference (opens in new window)
-- K                                                    show to documentation (opens in float)
-- wf                                                   format
-- :SwitchSH                                            swtich header file with implementation (cpp-specific)
--
-- fuzzy-find
-- ======================
-- ff                                                   open a fuzzy-find in current tab
-- fg                                                   open a ripgrep in current tab
-- ;;                                                   outline of file's structure
--
-- vim tabs modified
-- ======================
-- number + ]                                           go to tab with specified number (numbers are showed as part of the tabpage labels)
-- t + ]                                                go to the next tab
-- t + [                                                go to the previous tab
-- tw                                                   close the tab
-- :tabonly                                             close all tabs besides current
-- :tabfind [name]                                      find a file and open it in new tab
--
-- diffview & gitsigns
-- ======================
-- DiffviewOpen HEAD~2                                  compare HEAD~2 against current version
-- DiffviewOpen d4a7b0d                                 compare specific commit against current version
-- DiffviewOpen d4a7b0d^!                               compare changes introduced only by specific commit (behaves like `git show`)
-- DiffviewOpen origin/main...HEAD                      compare changes of HEAD against it's merge base 
-- DiffviewFileHistory                                  view diffs for changes made to this file
-- DiffviewFileHistory path/to/some/directory           view diffs for changes made to entire directory of files
-- DiffviewFileHistory --range=origin..HEAD             specify the range of changes to be viewed
--
-- gitsigns
-- ====================
-- ]c                                                   next hunk
-- [c                                                   previous hunk
-- C-b                                                  blame line
-- C-s                                                  stage hunk 
-- C-r                                                  reset hunk
-- C-p                                                  preview_hunk_inline
--
-- 
-- by RuS2m

