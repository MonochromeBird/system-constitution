{ pkgs, ... }:
{
	packages = with pkgs; [
		godot_4
		
		(pkgs.callPackage ./godot-mono-derivation.nix {})
		
		(pkgs.callPackage ./godot-mono-derivation.nix {
			bin_name = "godot4-mono-latest";
			repo = "godot-builds";
			version = "4.5-dev3";
			hash = "sha256-Emp453yqSFQCEMuXURZzKittL8L02rgxIHXg0QVuA6Q=";
		})
	];
}
