{ pkgs, law, ... }:
{
	username = "niki";

	packages = with pkgs; [
		librewolf
		kitty
		tldr
		
		pulsemixer
	];

	home = { config, ... }: {
		imports = [ (import ./config (law.allArgs // { inherit config; })) ];
	};
}

