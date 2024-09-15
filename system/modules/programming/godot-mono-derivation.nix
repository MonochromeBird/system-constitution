# Dependencies based off of https://github.com/NixOS/nixpkgs/pull/285941.
# I couldn't get the derivation in the PR to build, so I adapted it
# to just fetch the binaries directly.

{ pkgs ? import <nixpkgs> {} }: pkgs.stdenv.mkDerivation rec {
  version = "v4.3-stable";
  release = "Godot_${version}_mono_linux";
  bin = "${release}.x86_64";

  dirname = "${release}_x86_64";
  zipname = "${dirname}.zip";

  name = "Godot_${version}_mono";
  pname  = "godot4-mono";
  
  src = pkgs.fetchurl {
    url = "https://github.com/godotengine/godot/releases/download/${version}/${zipname}";
    hash = "sha256-7N881aYASmVowZlYHVi6aFqZBZJuUWd5BrdvvdnK01E=";
  };

  nativeBuildInputs = with pkgs; [
    unzip
    
    pkg-config
    autoPatchelfHook
    installShellFiles
    python3
    mono
    dotnet-sdk
    dotnet-runtime
  ];

  runtimeDependencies = with pkgs; [
    vulkan-loader
    libGL
    xorg.libX11
    xorg.libXcursor
    xorg.libXinerama
    xorg.libXext
    xorg.libXrandr
    xorg.libXrender
    xorg.libXi
    xorg.libXfixes
    libxkbcommon
    alsa-lib
    mono
    dotnet-sdk
    dotnet-runtime
    libpulseaudio
    dbus
    dbus.lib
    speechd
    fontconfig
    fontconfig.lib
    udev
  ];
  
  phases = [ "installPhase" ];
  
  installPhase = ''
    mkdir -p $out/bin
    unzip $src -d .

    autoPatchelf ./${dirname}/${bin}
    mv ./${dirname}/${bin} $out/bin/${pname}

    mv ./${dirname}/* $out/bin/
  '';
}
