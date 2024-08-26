{ lib
, stdenv
, fetchFromGitHub
, cmake
, asciidoc
, pkg-config

, buildFramework ? stdenv.hostPlatform.isDarwin

, enableDrafts ? true
, enableWebSocket ? enableDrafts
, enableRadixTree ? enableDrafts
, withTls ? enableWebSocket
, gnutls
, withNss ? enableWebSocket

, withLibbsd ? true
, libbsd

, enableCurve ? true
, withLibsodium ? true
, libsodium
, withGssapiKrb5 ? true
}:

assert enableCurve -> withLibsodium;
assert enableDrafts -> enableWebSocket;
assert enableDrafts -> enableRadixTree;

stdenv.mkDerivation rec {
  pname = "zeromq";
  version = "4.3.5";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "libzmq";
    rev = "v${version}";
    sha256 = "sha256-q2h5y0Asad+fGB9haO4Vg7a1ffO2JSb7czzlhmT3VmI=";
  };

  nativeBuildInputs = [ cmake asciidoc pkg-config ];
  buildInputs = []
    ++ lib.optional (withTls || withNss) gnutls
    ++ lib.optional withLibbsd libbsd
    ++ lib.optional withLibsodium libsodium
    ;

  doCheck = false; # fails all the tests (ctest)

  cmakeFlags = [
    (lib.cmakeBool "ZMQ_BUILD_FRAMEWORK" buildFramework)
    (lib.cmakeBool "ENABLE_DRAFTS" enableDrafts)
    (lib.cmakeBool "ENABLE_WS" enableWebSocket)
    (lib.cmakeBool "ENABLE_RADIX_TREE" enableRadixTree)
    (lib.cmakeBool "WITH_TLS" withTls)
    (lib.cmakeBool "WITH_NSS" withNss)
    (lib.cmakeBool "WITH_LIBBSD" withLibbsd)
    (lib.cmakeBool "ENABLE_CURVE" enableCurve)
    (lib.cmakeBool "WITH_LIBSODIUM" withLibsodium)
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '$'{prefix}/'$'{CMAKE_INSTALL_LIBDIR} '$'{CMAKE_INSTALL_FULL_LIBDIR} \
      --replace '$'{prefix}/'$'{CMAKE_INSTALL_INCLUDEDIR} '$'{CMAKE_INSTALL_FULL_INCLUDEDIR}
  '';

  meta = with lib; {
    branch = "4";
    homepage = "http://www.zeromq.org";
    description = "Intelligent Transport Layer";
    license = licenses.mpl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
