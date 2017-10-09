"execute pathogen#infect()
" set shortmess=aoOTI

" Use vim-plug as plugin manager
"    https://github.com/junegunn/vim-plug
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

Plug 'elmcast/elm-vim'

call plug#end()

set cmdheight=1

syntax on
set number
set mouse=a
set shiftwidth=2
"set softtabstop=2
set expandtab

set tabpagemax=20
set showtabline=1

" Add full file path to status line
"set statusline+=%<%F\ %h%m%r%y%=%-14.(%l,%c%V%)\ %P
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_python_checkers = ['python']

set laststatus=2

set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ %{v:servername}

" Allow %% to be use to reference a files directory
" such as ':tabe %%'
cabbr <expr> %% expand('%:p:h')

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

