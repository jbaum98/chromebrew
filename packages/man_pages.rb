require 'package'

class Man_pages < Package
  version '3.54'
  binary_url ({
    i686: "https://www.dropbox.com/s/us3wh39fib66mxd/man-pages.tar.gz?dl=0",
    x86_64: "https://www.dropbox.com/s/us3wh39fib66mxd/man-pages.tar.gz?dl=0"
  })
  binary_sha1 ({
    i686: "a868e911c83b01e808608000b863c8d374a58000",
    x86_64: "a868e911c83b01e808608000b863c8d374a58000"
  })
  
end
