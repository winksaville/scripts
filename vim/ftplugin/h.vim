" Two different styles for c formatting
" that can be toggled using <Space>k

"if ((&ft != 'c') && (&ft != 'h'))
"if (&ft != 'h')
"	finish
"endif

function! Normal_c_vim()
    set expandtab
    setlocal tabstop=2
    setlocal softtabstop=2
    setlocal shiftwidth=2
    setlocal colorcolumn=80
endfunction

function! Kernel_c_vim()
    " From https://github.com/osandov/dotfiles/blob/master/vim/after/ftplugin/c.vim
    " Linux kernel coding style (linux/Documentation/process/coding-style.rst).
    setlocal cindent
    setlocal cinoptions=:0,t0,(0
    setlocal noexpandtab
    setlocal shiftwidth=8
    setlocal softtabstop=0
    setlocal tabstop=8
    setlocal textwidth=80
    setlocal colorcolumn=80

    "nnoremap <F3> diwi#ifndef <Esc>po#define <Esc>p3a<CR><Esc>o#endif /* <Esc>pa */<Esc>2k
    "inoremap <F3> <Esc>diwi#ifndef <Esc>po#define <Esc>p3a<CR><Esc>o#endif /* <Esc>pa */<Esc>2ki
    "vnoremap <Leader>0 <Esc>`<O#if 0<Esc>`>o#endif<Esc>
    "nnoremap <Leader>{ A<Space>{<Esc>jo}<Esc>k^
    "nnoremap <Leader>} $diB"_daB"_Dp
endfunction

call Normal_c_vim()
let b:kernel_mode = 0
function! s:kernel_config()
    let b:kernel_mode = !b:kernel_mode
    if b:kernel_mode
      " enable kernel settings here
      :call Kernel_c_vim()
    else
      " enable non-kernel settings
      :call Normal_c_vim()
    endif
endfunction

nnoremap <buffer> <Space>k :call <SID>kernel_config()<CR>
