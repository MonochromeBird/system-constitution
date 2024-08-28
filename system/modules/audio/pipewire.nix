{ ... }:
{
	system = {
		services.pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
		};

		# Some modules such as certain desktop environments
		# may enable pulseaudio by default, and it conflicts
		# with pipewire.
		hardware.pulseaudio.enable = false;
	};
}
