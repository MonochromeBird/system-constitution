{ ... }:
{
	lawModules = [
		/core/nvidia
	];

	system = {
		imports = [ ./neopax-hw.nix ];

		boot.loader.systemd-boot.enable = true;
		boot.loader.efi.canTouchEfiVariables = true;

		hostname = "neopax";
	};
}

