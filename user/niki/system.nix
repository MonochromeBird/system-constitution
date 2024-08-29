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
		services = {
			xserver = {
				enable = true;
				displayManager.lightdm.enable = true;
				
				xkb = {
					layout = "us,br";
					options = "grp:alt_caps_toggle";
				};
			};

			syncthing = {
				enable = true;

				openDefaultPorts = true;
				
				# Seems to cause the entire configuration to be reset!
				# settings.options.urAccepted = -1;

				user = "niki";
				dataDir = "/home/niki/.local/share/syncthing";
				configDir = "/home/niki/.local/share/syncthing/config";
			};
		};
	};
}
