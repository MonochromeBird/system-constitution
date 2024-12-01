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

		services.pipewire.extraConfig.pipewire."92-low-latency" = {
			"context.properties" = {
    			"default.clock.rate" = 48000;
				"default.clock.quantum" = 512;
				"default.clock.min-quantum" = 512;
				"default.clock.max-quantum" = 512;
			};
		};
	};
}
