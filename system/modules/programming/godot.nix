{ pkgs, ... }:
{
	packages = with pkgs; [
		godot_4
		
		(pkgs.callPackage ./godot-mono-derivation.nix {})
		
		(pkgs.callPackage ./godot-mono-derivation.nix {
			bin_name = "godot4-mono-latest";
			repo = "godot-builds";
			version = "4.4-stable";
			hash = "sha256-xUU3zmEH9ZltvVizjb/4qN1EAWcgrU5bWLHlA0zlQ5M=";
		})
	];
}
