{ pkgs ? import <nixpkgs> {} }:
let
	commonDependencies = with pkgs; [
		pkg-config
		scons
		
		xorg.libX11
		xorg.libXinerama
		xorg.libXcursor
		xorg.libXrandr
		xorg.libXext
		xorg.libXi
		
		vulkan-loader
		libGL
		mesa
		
		alsaLib
		libvorbis
		
		freetype
		
		openssl
		
		libtheora
		libpng
		zlib
	];

	windowsDependencies = with pkgs; [
		pkgsCross.mingwW64.buildPackages.gcc
		
		wine
		
		(pkgs.fetchFromGitHub {
			owner = "lhmouse";
			repo = "mcfgthread";
			rev = "v1.8-ga.2";
			sha256 = "sha256-VxgdIHo5RgW5skiWDixoK7CjF8ALNLGM9gVbch6jFBk=";
		})
	];

	# macosDependencies = with pkgs; [
		# darwin.apple_sdk.frameworks.CoreAudio
		# darwin.apple_sdk.frameworks.CoreGraphics
		# darwin.apple_sdk.frameworks.CoreServices
		# darwin.apple_sdk.frameworks.Foundation
		# darwin.apple_sdk.frameworks.IOKit
	# ];
in
pkgs.mkShell {
	nativeBuildInputs = commonDependencies ++ windowsDependencies;
}
