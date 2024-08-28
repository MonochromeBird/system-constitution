{ ... }:
{
	lawModules = [
		/audio/jack-pipewire
		/network/anonymous
	];

	systemUsers = [
		"niki"
	];

	system = {
		services.xserver = {
			enable = true;
			displayManager.gdm.enable = true;
			windowManager.awesome.enable = true;
		};
	};
}
