{ pkgs, law, ... }:
{
	username = "niki";

	lawModules = [
		/network/tor

		/core/gnupg
		/core/fonts

		/programming/godot
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
		mpc-cli
		ncmpcpp
		
		sxhkd
		flameshot
		brightnessctl
		dmenu

		neovim
		emacs
	];

	system = {
		services.xserver.windowManager.awesome.enable = true;
	};

	home = { config, ... }: {
		imports = [ (import ./config (law.allArgs // { inherit config; })) ];

		services.unclutter = {
			enable = true;
			timeout = 2;
		};
	};
}

