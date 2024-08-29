{ ... }:
{
	lawModules = [
		/audio/jack-pipewire
		/network/anonymous
	];

	systemUsers = [ "alek" "niki" ];

	system = {
		services.displayManager.sddm.enable = true;
		
		services.xserver.xkb.layout  = "br";
		services.xserver.xkb.options = "grp:alt_caps_toggle";
	};
}
