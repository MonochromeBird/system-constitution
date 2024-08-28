{ pkgs, sandbox, opts, ... }:
{
	packages = [
		(sandbox.package pkgs.steam opts.sandbox)
	];

	allowedUnfree = [
		"steam"
		"steam-original"
		"steam-run"
		"steamcmd"
	];

	system = {
		hardware.graphics.enable32Bit = true;
		hardware.pulseaudio.support32Bit = true;

		programs.steam = {
			enable = true;
			remotePlay.openFirewall = true;
			dedicatedServer.openFirewall = true;
			localNetworkGameTransfers.openFirewall = true;
		};
	};
}
