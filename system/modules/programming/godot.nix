{ pkgs, ... }:
{
	packages = with pkgs; [
		godot_4
		
		(pkgs.callPackage ./godot-mono-derivation.nix {})
		
		(pkgs.callPackage ./godot-mono-derivation.nix {
			bin_name = "godot4-mono-latest";
			repo = "godot-builds";
			version = "4.4-beta2";
			hash = "sha256-5EQPQk2vSD7vdjoWbxGny42ONDJMXt35qjAdP9x7CUo=";
		})
	];
}
