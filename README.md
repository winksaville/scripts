# Scripts

These are scripts I've created over time and
when initializing a Linux system I clone this
from github as soon as possible copy:

Note: keep git-completion.bash upto date.

- bashrc to ~/.bashrc
- vimrc to ~/.vimrc
- gpg.conf to ~/.gnupg/
- dirmngr.conf to ~/.gnupg/
- gitconfig to ~/.gitconfig
- gitignore to ~/.gitignore
- in vim-openscad plugin added setting of tabstop ...:

```
wink@3900x:~/.vim/plugged/vim-openscad (master)
$ git diff
diff --git a/ftplugin/openscad.vim b/ftplugin/openscad.vim
index f3dd6d3..e6e7dca 100644
--- a/ftplugin/openscad.vim
+++ b/ftplugin/openscad.vim
@@ -1,5 +1,7 @@
 " Blatantly stolen from vim74\ftplugin\c.vim
 
+setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
+
 " Set 'formatoptions' to break comment lines but not other lines,
 " and insert the comment leader when hitting <CR> or using "o".
 setlocal fo-=t fo+=croql
```

