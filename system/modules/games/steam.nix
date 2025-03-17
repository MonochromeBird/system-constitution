{ pkgs, sandbox, opts, ... }:
{
	packages = [
		(sandbox.package pkgs.steam
			# https://github.com/ValveSoftware/steam-for-linux/issues/8859
			({ useRecommendedPreset = false; } // opts.sandbox))
	];

	allowedUnfree = [
		"steam"
		"steam-original"
		"steam-run"
		"steamcmd"
		"steam-unwrapped"
	];

	system = {
		hardware.graphics.enable32Bit = true;
		services.pulseaudio.support32Bit = true;

		programs.steam = {
			enable = true;
			remotePlay.openFirewall = true;
			dedicatedServer.openFirewall = true;
			localNetworkGameTransfers.openFirewall = true;
		};

		programs.nix-ld.libraries = with pkgs; [
			xorg.libxcb
		];
	};
}
