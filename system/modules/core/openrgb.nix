{ pkgs, ... }:
{
	packages = with pkgs; [
		openrgb-with-all-plugins
	];

	system.services.udev.packages = [ pkgs.openrgb-with-all-plugins ];
	system.boot.kernelModules = [ "i2c-dev" ];
	system.hardware.i2c.enable = true;
}

