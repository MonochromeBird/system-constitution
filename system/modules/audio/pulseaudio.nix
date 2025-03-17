{ lib, ... }:
{
	system = {
		services.pulseaudio.enable = true;
		services.pipewire.enable = lib.mkForce false;
	};
}
