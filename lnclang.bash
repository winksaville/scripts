# Must be run with sudo
if [[ $(clang --version) == 'clang version'* ]]; then
  echo "clang is installed"
  if [[ $(cc --version) != 'clang version'* ]]; then
    echo "symlink clang to cc"
    ln -sf $(which clang) $(which cc);
  else
    echo "cc is clang"
  fi
  if [[ $(c++ --version) != 'clang version'* ]]; then
    echo "symlink clang c++"
    ln -sf $(which clang++) $(which c++);
  else
    echo "c++ is clang"
  fi
  if [[ $(ld --version) != 'LLD '* ]]; then
    echo "symlink ld.lld to ld"
    ln -sf $(which ld.lld) $(which ld);
  else
    echo "ld is ld.lld"
  fi
fi

