#!/bin/bash
# Parameter 1 is version i.e: 2.24 or 2.26
if [ "" == "$1" ]; then
  echo "No paramter expecting 2.24 or 2.26 or .."
  exit 1
fi

ln -sf /usr/bin/x86_64-linux-gnu-addr2line-$1 /usr/bin/addr2line
ln -sf /usr/bin/x86_64-linux-gnu-ar-$1        /usr/bin/ar       
ln -sf /usr/bin/x86_64-linux-gnu-as-$1        /usr/bin/as       
ln -sf /usr/bin/x86_64-linux-gnu-c++filt-$1   /usr/bin/c++filt  
ln -sf /usr/bin/x86_64-linux-gnu-dwp-$1       /usr/bin/dwp      
ln -sf /usr/bin/x86_64-linux-gnu-elfedit-$1   /usr/bin/elfedit  
ln -sf /usr/bin/x86_64-linux-gnu-gold-$1      /usr/bin/gold    
ln -sf /usr/bin/x86_64-linux-gnu-gprof-$1     /usr/bin/gprof    
ln -sf /usr/bin/x86_64-linux-gnu-ld.bfd-$1    /usr/bin/ld        
ln -sf /usr/bin/x86_64-linux-gnu-ld.bfd-$1    /usr/bin/ld.bfd   
ln -sf /usr/bin/x86_64-linux-gnu-ld.gold-$1   /usr/bin/ld.gold  
ln -sf /usr/bin/x86_64-linux-gnu-nm-$1        /usr/bin/nm       
ln -sf /usr/bin/x86_64-linux-gnu-objcopy-$1   /usr/bin/objcopy  
ln -sf /usr/bin/x86_64-linux-gnu-objdump-$1   /usr/bin/objdump  
ln -sf /usr/bin/x86_64-linux-gnu-ranlib-$1    /usr/bin/ranlib   
ln -sf /usr/bin/x86_64-linux-gnu-readelf-$1   /usr/bin/readelf  
ln -sf /usr/bin/x86_64-linux-gnu-size-$1      /usr/bin/size     
ln -sf /usr/bin/x86_64-linux-gnu-strings-$1   /usr/bin/strings  
ln -sf /usr/bin/x86_64-linux-gnu-strip-$1     /usr/bin/strip    
