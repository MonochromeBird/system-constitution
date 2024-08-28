{ pkgs, ... }:
{
	imports = [ ./pipewire.nix ];
		
	groups = [ "jackaudio" ];

	system = {
		services.pipewire = {
			jack.enable = true;
		};
		
		environment.systemPackages = with pkgs; [
			libjack2
			jack2
			qjackctl
			pavucontrol
			libjack2
			jack2
			qjackctl
			jack2Full
			jack_capture
		];
	};
}
