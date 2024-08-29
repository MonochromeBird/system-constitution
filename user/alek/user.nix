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
		fish
		
		discord

		mpv		
		
		kitty
		tldr
	];

	system.imports	= [ ./config/desktop/plasma/system.nix ];
	
	home = { config, ... }: {
		imports = [ ./config/desktop/plasma/home.nix ];

		programs.zoxide = { enable = true; enableFishIntegration = true; } ;
		programs.fish = { enable = true; interactiveShellInit = "zoxide init fish | source"; };
		
		services.unclutter = {
			enable = true;
			timeout = 2;
		};
	};
}

