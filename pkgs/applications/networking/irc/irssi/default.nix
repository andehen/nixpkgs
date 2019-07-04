{ stdenv, fetchurl, pkgconfig, ncurses, glib, openssl, perl, libintl }:

stdenv.mkDerivation rec {
  version = "1.1.3";
  name = "irssi-${version}";

  src = fetchurl {
    url = "https://github.com/irssi/irssi/releases/download/${version}/${name}.tar.gz";
    sha256 = "05x4kgprbbdhiyvdrch9gyaal6qjivxbsjm8285ng3hlps03yjdj";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses glib openssl perl libintl ];

  configureFlags = [
    "--with-proxy"
    "--with-bot"
    "--with-perl=yes"
    "--enable-true-color"
  ];

  meta = {
    homepage    = https://irssi.org;
    description = "A terminal based IRC client";
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ lovek323 ];
    license     = stdenv.lib.licenses.gpl2Plus;
  };
}
