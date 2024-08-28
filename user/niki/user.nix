{ pkgs, law, ... }:
{
	username = "niki";

	lawModules = [
		/core/fonts
		/core/gnupg
	];

	packages = with pkgs; [
		librewolf
		kitty
		tldr
		
		pulsemixer

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

