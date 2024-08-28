{ pkgs, ... }:
{
	username = "niki";

	packages = with pkgs; [
		librewolf
		kitty
		tldr
		
		pulsemixer
	];
}

