execute pathogen#infect()
" set shortmess=aoOTI

syntax on
set number
set mouse=a
set shiftwidth=2
set softtabstop=2

set tabpagemax=20
set showtabline=1

" Syntastic suggested values
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" using clang-format mapped
map <C-I> :pyf ~/scripts/clang-format.py
"imap <C-I> <c-o>:pyf ~/scripts/clang-format.py

filetype plugin indent on

fun! JumpToDef()
  if exists("*GotoDefinition_" . &filetype)
    call GotoDefinition_{&filetype}()
  else
    exe "norm! \<C-]>"
  endif
endf

" Jump to tag
nn <M-g> :call JumpToDef()<cr>
ino <M-g> <esc>:call JumpToDef()<cr>i

" Change the matching highlighting
hi MatchParen cterm=bold ctermbg=none ctermfg=magenta
