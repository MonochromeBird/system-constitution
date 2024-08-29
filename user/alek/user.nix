{ pkgs, ... }:
{
	username = "alek";
	name = "Artifício";
	shell = pkgs.fish;

	lawModules = [
		/network/nordvpn
	
		/core/fonts
		/core/gnupg

		/programming/godot
		/programming/basic

		/games/steam
		/games/atlauncher
	];

	allowedUnfree = ["jetbrains-toolbox" "discord"];

	packages = with pkgs; [
		bottles
	
		jetbrains-toolbox
 		flameshot
		brave
		
		rofi
		
		oh-my-fish
		zoxide
		fish
		
		discord

		mpv		
		
		kitty
		tldr
	];

	system.imports	= [ ./config/desktop/plasma/system.nix ];
	
	home = { config, ... }: {
		imports = [ ./config/desktop/plasma/home.nix ];

		services.unclutter = {
			enable = true;
			timeout = 2;
		};
	};
}

