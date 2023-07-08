{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libva
, libdrm
}:

stdenv.mkDerivation rec {
  pname = "oneVPL-intel-gpu";
  version = "23.2.4";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneVPL-intel-gpu";
    rev = "intel-onevpl-${version}";
    sha256 = "sha256-v6SMAFI2bYmn0jz5Tb9fjg+/KXpaEXqur+2FoCa7pAk=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libva libdrm ];

  meta = {
    description = "oneAPI Video Processing Library Intel GPU implementation";
    homepage = "https://github.com/oneapi-src/oneVPL-intel-gpu";
    changelog = "";
    license = [ lib.licenses.mit ];
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.evanrichter ];
  };
}
