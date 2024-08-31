{ pkgs, ... }:
{
	imports = [ ./pipewire.nix ];
		
	groups = [ "jackaudio" ];

	system = {
		services.pipewire = {
			enable = true;
			
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
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
