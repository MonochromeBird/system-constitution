{ ... }:
{
	lawModules = [
		/audio/jack-pipewire
		/network/anonymous
	];

	systemUsers = [ "alek" ];

	system = {
		imports	= [ ./config/desktop/plasma/system.nix ];
		
		services.xserver.xkb.layout  = "br";
		services.xserver.xkb.options = "grp:alt_caps_toggle";
	};
}
