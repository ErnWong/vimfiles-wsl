hi clear
if (exists("syntax_on"))
  syntax reset
endif

runtime bundle/gruvbox/colors/gruvbox.vim

let g:colors_name = "my-gruvbox"


" Manually swap fg and bg to emulate a cterm=reverse

highlight Search     guifg=#282828 guibg=#fabd2f
highlight IncSearch  guifg=#282828 guibg=#fe8019
"highlight StatusLine guifg=#504945 guibg=#ebdbb2
highlight ERROR      guifg=bg      guibg=#fb4934
highlight DiffDelete guifg=#282828 guibg=#fb4934
highlight DiffAdd    guifg=#282828 guibg=#b8bb26
highlight DiffChange guifg=#282828 guibg=#8ec07c
highlight DiffText   guifg=#282828 guibg=#fabd2f


" Might want to play around with in the future:

" highlight lineNr ctermbg=0
" highlight clear CursorLine
" highlight CursorLine ctermbg=0
" highlight CursorLineNr ctermbg=0
" highlight ColorColumn ctermbg=0
" highlight clear VertSplit
" highlight VertSplit ctermbg=15 ctermfg=0
" highlight Normal ctermbg=0
