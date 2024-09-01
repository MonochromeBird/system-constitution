{
	config,
	lib,
	pkgs,
	system,
	nixpkgs-stable,
	nixpkgs-unstable,
	lawConfig,
	...
}: {
	options = {
		allowedUnfree = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [ ];
		};

		hostname = lib.mkOption {
			type = lib.types.str;
			default = config.system.nixos.distroId;
		};

		identifier = lib.mkOption {
			type = lib.types.str;
			default = config.system.nixos.distroId;
		};

		# Not a real option! Used to spread other instances of nixpkgs
		# while using the same unfree predicate function.
		pkgs-stable = lib.mkOption {
			type = lib.types.attrs;
			default = import nixpkgs-stable {
				inherit system;
				config.allowUnfreePredicate = config.nixpkgs.config.allowUnfreePredicate;
			};
		};

		pkgs-unstable = lib.mkOption {
			type = lib.types.attrs;
			default = import nixpkgs-unstable {
				inherit system;
				config.allowUnfreePredicate = config.nixpkgs.config.allowUnfreePredicate;
			};
		};
	};

	config = {
		nixpkgs.config = {
			allowUnfreePredicate = pkg: lib.elem (lib.getName pkg) config.allowedUnfree;
		};

		networking = {
			hostName = lib.mkDefault config.hostname;
			networkmanager.enable = lib.mkDefault true;
		};

		time.timeZone = lib.mkDefault "Universal";

		i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

		i18n.extraLocaleSettings = lib.mkDefault {
			LC_ADDRESS = "en_US.UTF-8";
			LC_IDENTIFICATION = "en_US.UTF-8";
			LC_MEASUREMENT = "en_US.UTF-8";
			LC_MONETARY = "en_US.UTF-8";
			LC_NAME = "en_US.UTF-8";
			LC_NUMERIC = "en_US.UTF-8";
			LC_PAPER = "en_US.UTF-8";
			LC_TELEPHONE = "en_US.UTF-8";
			LC_TIME = "en_US.UTF-8";
		};

		services.xserver.xkb.layout = lib.mkDefault "us";

		environment = {
			systemPackages = with pkgs; [
				(writeShellScriptBin "sysid" ''echo ${config.identifier}'')

				(writeShellScriptBin "punir" ''NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 NIXPKGS_ALLOW_UNFREE=1 nix run nixpkgs#$1 --impure -- ''${@:2}'')
				(writeShellScriptBin "unir" ''NIXPKGS_ALLOW_UNFREE=1 nix run nixpkgs#$1 --impure -- ''${@:2}'')
				(writeShellScriptBin "nir" ''nix run nixpkgs#$1 -- ''${@:2}'')

				(writeShellScriptBin "nxs" ''nix search nixpkgs $@'')
				(writeShellScriptBin "nrepl" ''nix repl --expr "import <nixpkgs>{}"'')

				(writeShellScriptBin "nrb" ''${lawConfig.absolutePath}/rebuild.sh'')
				(writeShellScriptBin "ncrb" ''nix-collect-garbage -d && sudo nix-collect-garbage -d && ${lawConfig.absolutePath}/rebuild.sh'')

				(writeShellScriptBin "warp" ''nix-shell ${lawConfig.absolutePath}/system/environments/$1.nix && echo "warped out"'')

				neovim
				vim
				tmux
				wget

				git
				openssh
				openssl
				
				busybox
				
				file
				tree
			];

			variables = {
				HOSTNAME = "${config.hostname}";
			};
		};

		hardware = {
			bluetooth = {
				enable = lib.mkDefault true;
				powerOnBoot = lib.mkDefault false;
			};

			graphics.enable = lib.mkDefault true;
		};

		programs = {
			firejail.enable = lib.mkDefault true;
			dconf.enable = lib.mkDefault true;
			nix-ld.enable = lib.mkDefault true;
		};

		system.stateVersion = lib.mkDefault lawConfig.system.stateVersion;
		nix.settings.experimental-features = [ "nix-command" "flakes" ];
	};
}
