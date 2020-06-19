# Must be run with sudo
if [[ $(gcc --version) == 'gcc (GCC)'* ]]; then
  echo "gcc is installed"
  if [[ $(cc --version) != 'cc (GCC)'* ]]; then
    echo "symlink gcc to cc"
    ln -sf $(which gcc) $(which cc);
  else
    echo "cc is gcc"
  fi
  if [[ $(c++ --version) != 'c++ (GCC)'* ]]; then
    echo "symlink g++ to c++"
    ln -sf $(which g++) $(which c++);
  else
    echo "c++ is g++"
  fi
  if [[ $(ld --version) != 'GNU ld'* ]]; then
    echo "symlink ld.bfd to ld"
    ln -sf $(which ld.bfd) $(which ld);
  else
    echo "ld is ld.bfd"
  fi
fi

