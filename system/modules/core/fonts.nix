{ pkgs, ... }:
{
	system.fonts.packages = with pkgs; [
		jetbrains-mono
		noto-fonts
		dejavu_fonts
		terminus_font_ttf
	];
}
