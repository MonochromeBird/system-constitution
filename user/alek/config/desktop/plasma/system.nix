{ config, pkgs, ... }:
{
	services.desktopManager.plasma6.enable = true;
	services.xserver.enable = true;

	environment.systemPackages = with pkgs; [
		kdeconnect
		konsave
	];
}