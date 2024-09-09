{ config, nur-modules, pkgs, ... }:
{
	system = {
		imports = [
			nur-modules.repos.LuisChDev.modules.nordvpn
		];

		nixpkgs.config.packageOverrides = pkgs: {
			nordvpn = config.nur.repos.LuisChDev.nordvpn;
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
