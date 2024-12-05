{ pkgs, ... }:
{
	packages = with pkgs; [
		godot_4
		
		(pkgs.callPackage ./godot-mono-derivation.nix {})
		
		(pkgs.callPackage ./godot-mono-derivation.nix {
			bin_name = "godot4-mono-latest";
			repo = "godot-builds";
			version = "4.4-dev6";
			hash = "sha256-RaexKl+2/QfqIS+US/g+IAQdtWP6BbWsyMgIY67uT1k=";
		})
	];
}
