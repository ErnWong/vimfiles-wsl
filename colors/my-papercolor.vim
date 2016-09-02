hi clear
if (exists("syntax_on"))
  syntax reset
endif

runtime colors/default.vim

let g:colors_name = "my-papercolor"

highlight lineNr ctermfg=8
highlight clear CursorLine
highlight CursorLine ctermbg=7
highlight CursorLineNr ctermbg=7 ctermfg=0
highlight ColorColumn ctermbg=white
highlight clear VertSplit
highlight VertSplit ctermbg=15 ctermfg=0
