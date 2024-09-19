{ lib, ... }:
{
	system = {
		hardware.pulseaudio.enable = true;
		services.pipewire.enable = lib.mkForce false;
	};
}
