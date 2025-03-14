# Dependencies based off of https://github.com/NixOS/nixpkgs/pull/285941.
# I couldn't get the derivation in the PR to build, so I adapted it
# to just fetch the binaries directly.

{
  pkgs ? import <nixpkgs> {},
  version ? "4.3-stable",
  bin_name ? "godot4-mono",
  repo ? "godot",
  hash ? "sha256-7N881aYASmVowZlYHVi6aFqZBZJuUWd5BrdvvdnK01E="
}: pkgs.stdenv.mkDerivation rec {
  release = "Godot_v${version}_mono_linux";
  bin = "${release}.x86_64";

  dirname = "${release}_x86_64";
  zipname = "${dirname}.zip";

  name = "Godot_${version}_mono";
  pname = bin_name;
  
  src = pkgs.fetchurl {
    url = "https://github.com/godotengine/${repo}/releases/download/${version}/${zipname}";
    hash = hash;
  };

  nativeBuildInputs = with pkgs; [
    unzip
    
    pkg-config
    autoPatchelfHook
    installShellFiles
    python3
    mono
    dotnet-sdk_9
    dotnet-runtime_9
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
    dotnet-sdk_9
    dotnet-runtime_9
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
