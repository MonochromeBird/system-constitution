{ pkgs ? import <nixpkgs> {} }: pkgs.mkShell {
  packages = with pkgs; [ deno gradle jdk21 jdt-language-server ];

  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (with pkgs; [
    libpulseaudio
    libGL
    glfw
    openal
    stdenv.cc.cc.lib
  ]);
}
