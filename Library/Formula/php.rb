require 'formula'

class Php <Formula
  @version='5.3.1'
  @url='http://us.php.net/get/php-5.3.1.tar.gz/from/this/mirror'
  @homepage='http://php.net/'
  @md5='41fbb368d86acb13fc3519657d277681'
  
  def patches
    DATA
  end
  
  def options
    [
      ["--without-mysql", "Disable MySQL."],
      ["--without-sockets", "Disable sockets."],
      ["--without-pear", "Disable PEAR."]
    ]
  end
  
  def deps
    dependencies = super

    dependencies << 'gettext'
    dependencies << 'readline'
    dependencies << 'jpeg'
    dependencies << 'libpng'
    dependencies << 'libxml2'
    dependencies << 'mcrypt'
    dependencies << 'mysql' unless ARGV.include? '--without-mysql'
    
    dependencies
  end

  def install
    args = ["--prefix=#{prefix}",
            "--with-config-file-path=#{etc}",
            "--disable-debug",
            "--with-gd",
            "--with-zlib",
            "--with-jpeg-dir=#{Formula.factory('jpeg').prefix}",
            "--with-png-dir=#{Formula.factory('libpng').prefix}",
            "--with-libxml-dir=#{Formula.factory('libxml2').prefix}",
            "--with-curl=#{Formula.factory('mcrypt').prefix}",
            "--with-mcrypt=",
            "--with-mhash",
            "--with-xsl",
            "--with-gettext=#{Formula.factory('gettext').prefix}",
            "--with-bz2=/usr",
            "--with-openssl=/usr",
            "--enable-bcmath",
            "--enable-calendar",
            "--enable-fastcgi",
            "--enable-force-cgi-redirect",
            "--enable-exif",
            "--enable-ftp",
            "--enable-mbstring",
            "--enable-soap",
            "--enable-cli",
            "--enable-wddx",
            "--enable-zip"
# we need to create additional formulars for that
#           "--with-t1lib=/usr/local",
#           "--with-freetype-dir=/usr/local",
#           "--enable-gd-native-ttf",
    ]
    
    # probe for mysql
    unless ARGV.include? "--without-mysql"
      puts "Building with MySQL support. Please use --without-mysql if you want to skip this.\n"
      
      args.push "--with-mysql=#{Formula.factory('mysql').prefix}|"
      args.push "--with-mysqli=#{Formula.factory('mysql').bin}/mysql_config"
      args.push "--enable-pdo"
      args.push "--with-pdo-mysql=#{Formula.factory('mysql').prefix}"
    end
    
    # probe for sockets
    unless ARGV.include? "--without-sockets"
      puts "Building with sockets support. Please use --without-sockets if you want to skip this.\n"
      args.push "--enable-sockets"
    end

    # probe for pear
    unless ARGV.include? "--without-pear"
      puts "Building with PEAR support. Please use --without-pear if you want to skip this.\n"
      args.push "--with-pear"
    end
    
    # time consuming warning
    puts "Please be patient - this one is gonna take a while.\n"
    
    system "./configure", *args
                          
    system "make"
    system "make install"
  end
end
__END__
diff -Naur php-5.3.0/ext/iconv/iconv.c php/ext/iconv/iconv.c
--- php-5.3.0/ext/iconv/iconv.c	2009-03-16 22:31:04.000000000 -0700
+++ php/ext/iconv/iconv.c	2009-07-15 14:40:09.000000000 -0700
@@ -51,9 +51,6 @@
 #include <gnu/libc-version.h>
 #endif
 
-#ifdef HAVE_LIBICONV
-#undef iconv
-#endif
 
 #include "ext/standard/php_smart_str.h"
 #include "ext/standard/base64.h"
@@ -182,9 +179,6 @@
 }
 /* }}} */
 
-#ifdef HAVE_LIBICONV
-#define iconv libiconv
-#endif
 
 /* {{{ typedef enum php_iconv_enc_scheme_t */
 typedef enum _php_iconv_enc_scheme_t {

