{ sources ? import ./sources.nix }:
let pkgs = import sources.nixpkgs { };
in pkgs.stdenv.mkDerivation rec {
  pname = "zephyr";
  version = "custom";

  # Added as niv dependency
  # Attention: on macOS -> different tarball url!
  src = sources.zephyr;

  nativeBuildInputs = [ ]
    ++ pkgs.lib.optional pkgs.stdenv.isDarwin pkgs.fixDarwinDylibNames;

  buildInputs = [ pkgs.stdenv.cc.cc.lib pkgs.gmp pkgs.zlib pkgs.ncurses6 ];

  libPath = pkgs.lib.makeLibraryPath buildInputs;

  dontStrip = true;

  unpackPhase = ''
    mkdir -p $out/bin
    cp -r $src/* $out

    ZEPHYR=$out/bin/zephyr
    install -D -m555 -T $out/zephyr $ZEPHYR

    chmod u+w $ZEPHYR
  '' + pkgs.lib.optionalString (!pkgs.stdenv.isDarwin) ''
    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath ${libPath} $ZEPHYR
  '' + ''
    chmod u-w $ZEPHYR

    mkdir -p $out/etc/bash_completion.d/
    $ZEPHYR --bash-completion-script $ZEPHYR > $out/etc/bash_completion.d/zephyr-completion.bash
  '';

  dontInstall = true;
}
