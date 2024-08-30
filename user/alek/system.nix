{ ... }:
{
	lawModules = [
		/audio/jack-pipewire
		/network/anonymous
	];

	systemUsers = [ "alek" ];
	users = [ "niki" ];

	system = {
		services.displayManager.sddm.enable = true;
		
		services.xserver = {
			xkb.layout  = "br";
			xkb.options = "grp:alt_caps_toggle";
		};
	};
}
