{ ... }:
{
	lawModules = [
		/core/nvidia
	];

	system = {
		imports = [ ./hardware.nix ];

		boot.loader.systemd-boot.enable = true;
		boot.loader.efi.canTouchEfiVariables = true;

		hostname = "neopax";

		boot.initrd.luks.devices."ssd".device = "/dev/disk/by-uuid/e2b3c329-60db-42fb-a13f-828116fd2409";

		fileSystems."/home/niki/playground/mnt/ssd" = {
			device = "/dev/disk/by-uuid/7235dfd8-4b9b-470d-82d4-5e1a8849e21b";
			fsType = "ext4";
			options = [ "nofail" ];
		};
	};
}

