{ pkgs, law, ... }:
{
	username = "niki";

	packages = with pkgs; [
		librewolf
		kitty
		tldr
		
		pulsemixer

		mpd
		ncmpcpp
		sxhkd
		flameshot
	];

	home = { config, ... }: {
		imports = [ (import ./config (law.allArgs // { inherit config; })) ];

		services.unclutter = {
			enable = true;
			timeout = 2;
		};
	};
}

