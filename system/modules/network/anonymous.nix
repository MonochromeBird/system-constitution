{ lib, ... }:
{
	system = {
		networking.networkmanager.ethernet.macAddress = "random";
		networking.networkmanager.wifi.macAddress = "random";
		networking.networkmanager.wifi.scanRandMacAddress = true;

		networking.networkmanager.settings.main.hostname-mode = "none";

		networking.hostName = lib.mkForce "";
	};
}
