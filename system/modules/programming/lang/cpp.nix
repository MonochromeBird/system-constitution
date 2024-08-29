{ pkgs, ... }:
{
	packages = with pkgs; [
		clang-tools
		clang
		gcc14

		pkg-config
		
		gnumake
		cmake
		scons
		ninja
		
		gdb
	];
}
