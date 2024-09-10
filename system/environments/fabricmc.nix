{ pkgs ? import <nixpkgs> {} }: pkgs.mkShell {
  packages = with pkgs; [
    jdk21
    jdt-language-server
    kotlin-language-server
    gradle
    deno
  ];

  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (with pkgs; [
    libpulseaudio
    libGL
    glfw
    openal
    stdenv.cc.cc.lib
  ]);
}
