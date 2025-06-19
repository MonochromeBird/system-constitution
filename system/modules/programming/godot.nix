{ pkgs, ... }:
{
	packages = with pkgs; [
		godot_4
		
		(pkgs.callPackage ./godot-mono-derivation.nix {})
		
		(pkgs.callPackage ./godot-mono-derivation.nix {
			bin_name = "godot4-mono-latest";
			repo = "godot-builds";
			version = "4.5-beta1";
			hash = "sha256-JQShoa4EgVaxcSCjuR0QifFuJlg8guTsg3avPvv9iHQ=";
		})
	];
}
