set nocompatible
set encoding=utf-8
scriptencoding utf-8


"
" Plugins
"


call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'

" Intelligence:
Plug 'scrooloose/syntastic'
Plug 'editorconfig/editorconfig-vim'
Plug 'neoclide/coc.nvim'

" Languages:
Plug 'tpope/vim-liquid'
Plug 'PProvost/vim-ps1'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'iamcco/markdown-preview.nvim'
Plug 'othree/yajs.vim'
Plug 'gcorne/vim-sass-lint'
Plug 'rust-lang/rust.vim'
Plug 'HerringtonDarkholme/yats.vim'

" Handy:
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" UI:
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'christoomey/vim-tmux-navigator'
Plug 'qpkorr/vim-bufkill'
Plug 'francoiscabrol/ranger.vim'
Plug 'majutsushi/tagbar'

" Git:
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'

" Colorschemes:
Plug 'morhetz/gruvbox'

call plug#end()


"
" Mappings
"


let mapleader = '\\'
inoremap jk <esc>
nnoremap <space> :
vnoremap <space> :

" Close current buffer
nnoremap <C-c> :BD<cr>

" Tagbar
nmap <f8> :TagbarToggle<cr>

" Window navigation
" - inspired from nicknisi
" - <C-hjkl> moves only, via tmux navigator
" - <C-w> hjkl creates new split
nnoremap <C-w>h :wincmd v<cr>
nnoremap <C-w>j :wincmd s<cr>:wincmd k<cr>
nnoremap <C-w>k :wincmd s<cr>
nnoremap <C-w>l :wincmd v<cr>:wincmd l<cr>

" Using Windows clipboard inside WSL Ubuntu
" This emulates an additional '"' register
" I know... it's magical...
" Note: requires paste.exe on the PATH
let is_this_not_on_wsl = system("uname -r | grep -q 'Microsoft' && echo $?")
if is_this_not_on_wsl == 0
  nnoremap <silent> ""y :set opfunc=WindowsYank<CR>g@
  vnoremap <silent> ""y :<C-U>call WindowsYank(visualmode(), 1)<CR>
  nnoremap <silent> ""p :call WindowsPaste('p')<CR>
  nnoremap <silent> ""P :call WindowsPaste('P')<CR>
  nnoremap <silent> ""gp :call WindowsPaste('gp')<CR>
  nnoremap <silent> ""gP :call WindowsPaste('gP')<CR>
  nnoremap <silent> ""]p :call WindowsPaste(']p')<CR>
  nnoremap <silent> ""[p :call WindowsPaste('[p')<CR>
  nnoremap <silent> ""]P :call WindowsPaste(']P')<CR>
  nnoremap <silent> ""[P :call WindowsPaste('[P')<CR>
  vnoremap <silent> ""p :call WindowsPaste('p', 1)<CR>
  vnoremap <silent> ""P :call WindowsPaste('P', 1)<CR>
endif

function! WindowsPaste(command, ...)
  " (1) Save original value of the unnamed register to restore later on
  let reg_save = @@

  " (2) Load clipboard into register
  let @@ = system('pushd /mnt/c/ > /dev/null && paste.exe && popd > /dev/null')

  " (3) Run whatever command was being run
  if a:0
    exe "normal! gv" . a:command
    " Don't revert unnamed register if inside visual mode
  else
    exe "normal! " . a:command
    " Revert unnamed register
    let @@ = reg_save
  endif
endfunction

function! WindowsYank(type, ...)
  " (1) Save original values for the selection setting
  " and the unnamed register
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @@

  " (2) Yank text to unnamed register
  if a:0  " Invoked from Visual mode, use gv command.
    silent exe "normal! gvy"
  elseif a:type == 'line'
    silent exe "normal! '[V']y"
  else
    silent exe "normal! `[v`]y"
  endif

  " (3) Send contents of @@ to Windows clip.exe
  " Note: I've included a pushd-to-windows-directory to suppress warning
  " because windows warns about failing to translate working directory
  " when current working directory is inside wsl.
  echo system('pushd /mnt/c/ > /dev/null && clip.exe && popd > /dev/null', getreg('', 1, 1))

  " (4) Restore original settings and value of unnamed register
  let &selection = sel_save
  let @@ = reg_save
endfunction


"
" Backup & Persistance
"


" Backup
" - custom full path filenames
" - http://stackoverflow.com/a/38479550
" - writebackup = um... I forgot...
" - SaveBackups() by Victor Schroder
set nobackup
set writebackup
set backupdir=~/.vim/backup//

autocmd BufWritePre * :call SaveBackups()

function! SaveBackups()
  if expand('%:p') =~ &backupskip | return | endif
  if !filereadable(expand('%')) | return | endif
  for l:backupdir in split(&backupdir, ',')
    :call SaveBackup(l:backupdir)
    break
  endfor
endfunction

function! SaveBackup(backupdir)
  let l:filename = expand('%:p')
  if a:backupdir =~ '//$'
    let l:backup = escape(substitute(l:filename, '/', '%', 'g').&backupext, '%')
  else
    let l:backup = escape(expand('%').&backupext, '%')
  endif
  let l:backup_path = a:backupdir.l:backup
  :silent! execute '!cp "'.resolve(l:filename).'" "'.l:backup_path.'"'
endfunction

" Undo
" - double slash for complete path filenames
set undofile
set history=100
set undolevels=100
set undodir=~/.vim/undo//

" Swap
" - double slash for complete path filenames
set swapfile
set directory=~/.vim/swap//


"
" User Interface
"


set colorcolumn=100
set hlsearch
set number
set relativenumber
set numberwidth=4
set cursorline
set scrolloff=10
set listchars=tab:→\ ,trail:⋅
set list
set lazyredraw
set cmdheight=2

" (From coc.nvim README)
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Alt: ─
set fillchars=fold:-,vert:│

" Always show status line
set laststatus=2

" Hide the '-- INSERT --' or the '-- [something mode] --'
" and use the airline status instead
set noshowmode

" Colorscheme
let g:gruvbox_italic = 1
let g:gruvbox_bold = 1
colorscheme gruvbox
set background=dark
set termguicolors
set t_8f=[38;2;%lu;%lu;%lum " Needed in tmux
set t_8b=[48;2;%lu;%lu;%lum " Needed in tmux
set t_ZH=[3m " Italics
set t_ZR=[23m " End italics
syntax on

" Colors gets messed up in large files otherwise...
autocmd BufEnter * syntax sync fromstart

" Airline
let g:airline_theme='gruvbox'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = '│'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.crypt = '⌂'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.spell = '$'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'


"
" Intelligence
"


let g:syntastic_sass_checkers=["sasslint"]
let g:syntastic_scss_checkers=["sasslint"]
" Inspired by sblask (github.com/sblask/dotfiles)
fun! SetScssConfig()
  let l:configFile = findfile('.sass-lint.yml', '.;')
  if l:configFile != ''
    let b:syntastic_scss_scss_lint_args = '--config ' . l:configFile
  endif
endf
autocmd FileType scss :call SetScssConfig()

let g:ale_completion_enabled = 1
let g:deoplete#enable_at_startup = 1
let g:rustfmt_autosave = 1

" Coc extensions to install
let g:coc_global_extensions = [
      \ 'coc-marketplace',
      \ 'coc-pairs',
      \ 'coc-xml',
      \ 'coc-json',
      \ 'coc-yaml',
      \ 'coc-toml',
      \ 'coc-gitignore',
      \ 'coc-rust-analyzer',
      \ 'coc-java',
      \ 'coc-tsserver',
      \ 'coc-eslint',
      \ 'coc-vimlsp',
      \ 'coc-pyright',
      \ 'coc-powershell',
      \ 'coc-sh',
      \ 'coc-sql',
      \ 'coc-docker',
      \ 'coc-vimtex',
      \ 'coc-css',
      \ 'coc-prettier',
      \]

" Coc useful settings

" (From coc.nvim README)
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" (From coc.nvim README)
" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" (From coc.nvim README)
" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" (From coc.nvim README)
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" (From coc.nvim README)
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" (From coc.nvim README)
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" (From coc.nvim README)
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" (From coc.nvim README)
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" (From coc.nvim README)
" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" (From coc.nvim README)
" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" (From coc.nvim README)
" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" (From coc.nvim README)
" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" (From coc.nvim README)
" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" (From coc.nvim README)
" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" (From coc.nvim README)
" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" (From coc.nvim README)
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" (From coc.nvim README)
" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" (From coc.nvim README)
" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" (From coc.nvim README)
" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space><space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space><space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space><space>c  :<C-u>CocList commands<cr>
" Find symbol of current d<space>ocument.
nnoremap <silent><nowait> <space><space>o  :<C-u>CocList outline<cr>
" Search workspace symbols<space>.
nnoremap <silent><nowait> <space><space>s  :<C-u>CocList -I symbols<cr>
" Do default action for ne<space>xt item.
nnoremap <silent><nowait> <space><space>j  :<C-u>CocNext<CR>
" Do default action for pr<space>evious item.
nnoremap <silent><nowait> <space><space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space><space>p  :<C-u>CocListResume<CR>

"
" Editor Settings
"


set tabstop=2
set shiftwidth=2
set expandtab
set breakindent
set noautochdir

" Keep hidden buffers
set hidden

" Faster updates, e.g. for git gutter
set updatetime=100

" Mouse
set mouse=a
behave mswin
