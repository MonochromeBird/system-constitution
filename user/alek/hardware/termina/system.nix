{ ... }:
{
	lawModules = [
		/core/nvidia
	];

	system = {
		imports = [ ./generated.nix ];

		boot.loader.systemd-boot.enable = true;
		boot.loader.efi.canTouchEfiVariables = true;

		hostname = "termina";

		fileSystems."/mnt/Game" = { 
			device = "/dev/disk/by-uuid/67b50152-cd96-48b5-a78d-84d1992b82f4";
			fsType = "xfs";
			
			options = [
				"rw"
				"user"
				"exec"
				"nofail"
				"defaults"
			];
		};
		
		fileSystems."/mnt/Docs" = { 
			device = "/dev/disk/by-uuid/e74c2833-c605-403a-8572-8a1527de8a77";
			fsType = "ext4";
			
			options = [
				"rw"
				"user"
				"exec"
				"nofail"
				"defaults"
			];
		};
	};
}
