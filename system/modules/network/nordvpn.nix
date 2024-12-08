{ config, nur-modules, pkgs, pkgs-unstable, system, ... }:
{
	system = {
		imports = [
			nur-modules.repos.LuisChDev.modules.nordvpn
		];

		nixpkgs.config.packageOverrides = prev: {
			# nordvpn = pkgs-unstable.nur.repos.LuisChDev.nordvpn;
			nordvpn = pkgs.callPackage ./nur-nordvpn.nix {};
		};
		
		allowedUnfree = [ "nordvpn" ];
		
		services.nordvpn.enable = true;
		
		networking.firewall = {
			checkReversePath = false;
			allowedTCPPorts = [ 443 ];
			allowedUDPPorts = [ 1194 ];
		};

		environment.systemPackages = with pkgs; [
			(writeShellScriptBin "nv" ''nordvpn $@'')
			(writeShellScriptBin "nvc" ''nordvpn c $@'')
			(writeShellScriptBin "nvs" ''nordvpn s $@'')
		];
	};
	
	groups = [ "nordvpn" ];
}
