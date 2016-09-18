execute pathogen#infect()
" set shortmess=aoOTI

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
set statusline+=%<%F\ %h%m%r%y%=%-14.(%l,%c%V%)\ %P
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

