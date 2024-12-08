{
	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable";
		nixpkgs-stable.url = "nixpkgs/nixos-24.05";
		nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

		nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		
		nur = {
			url = "github:nix-community/NUR";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputArgs@{ nixpkgs, nixos-cosmic, nixpkgs-stable, nixpkgs-unstable, home-manager, nur, ... }:
		let
			args = inputArgs // {
				system = "x86_64-linux";

				systemPath = ./system;
				userPath = ./user;

				lawConfig = import ./config.nix;

				nur-modules = import nur {
					nurpkgs = nixpkgs.legacyPackages.x86_64-linux;
				};
			};

			nixosCustomSystem = { modules, identifier }: nixpkgs.lib.nixosSystem {
				system = args.system;
				specialArgs = args;

				modules = [
					./system/global.nix
					nur.modules.nixos.default

					#######################################################################################################
					# Cosmic																																															#
					#######################################################################################################
					{
						nix.settings = {
							substituters = [ "https://cosmic.cachix.org/" ];
							trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
						};
					}
					nixos-cosmic.nixosModules.default
					#######################################################################################################

					home-manager.nixosModules.home-manager

					{ config.identifier = identifier; }

					({ config, lib, pkgs, ... }: {imports = [
						((import ./system/law.nix (args // {
							inherit config lib pkgs;
							pkgs-stable = config.pkgs-stable;
							pkgs-unstable = config.pkgs-unstable;
						})).makeSystemModulesByPath modules)
					];})
				];
			};

			lib = nixpkgs.lib;
			utils = import ./system/utils.nix { inherit lib; };

			extractConfigurationsFromUserDirectory = user:
			let
				userDirectory = ./. + "/user/${user}";
				hardwareDirectory = ./. + "/user/${user}/hardware";
			in
				lib.attrsets.mergeAttrsList (if (utils.hasDirectory userDirectory "hardware") then
					(lib.lists.forEach (utils.getDirectories hardwareDirectory)
						(hardwareIdentifier: let fullIdentifier = "${user}.${hardwareIdentifier}"; in {
							"${fullIdentifier}" = lib.concatLists [
								[
									(./. + "/user/${user}/hardware/${hardwareIdentifier}/system.nix")
								]
								
								(
									if (utils.hasFile userDirectory "system.nix")
									then [ (./. + "/user/${user}/system.nix") ]
									else []
								)
							];
						})
					)
				else []);

			lawMachines = (lib.attrsets.mergeAttrsList
				(lib.lists.forEach (utils.getDirectories ./user)
					(user: extractConfigurationsFromUserDirectory user)));
		in {
		nixosConfigurations = lib.attrsets.mapAttrs
			(name: moduleList: nixosCustomSystem {
				modules = moduleList;
				identifier = name;
			}) lawMachines;
	};
}
