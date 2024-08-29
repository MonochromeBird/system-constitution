{ pkgs, law, ... }:
{
	username = "niki";

	lawModules = [
		/core/fonts
		/core/gnupg

		/programming/godot/default
		/programming/basic

		/games/steam
		/games/atlauncher
	];

	packages = with pkgs; [
		librewolf
		kitty
		tldr
		
		pulsemixer
		
		sxiv
		mpv
		
		mpd
		ncmpcpp
		
		sxhkd
		flameshot
		brightnessctl
		dmenu
	];

	home = { config, ... }: {
		imports = [ (import ./config (law.allArgs // { inherit config; })) ];

		services.unclutter = {
			enable = true;
			timeout = 2;
		};
	};
}

