{ pkgs, ... }:
{
	packages = with pkgs; [
		godot_4
		
		(pkgs.callPackage ./godot-mono-derivation.nix {})
		
		(pkgs.callPackage ./godot-mono-derivation.nix {
			bin_name = "godot4-mono-latest";
			repo = "godot-builds";
			version = "4.4-dev3";
			hash = "sha256-K9AWkLnWCyIXPkFUkdAJbJuldrrrOX/8Ysun2iIdelI=";
		})

		(pkgs.callPackage ./godot-mono-derivation.nix {
			bin_name = "godot4-mono-4.4dev2";
			repo = "godot-builds";
			version = "4.4-dev2";
			hash = "sha256-/d+lRbUSG/WIpH+EXNfiA+H6bSWQlRtjdyBZ6XWP9bM=";
		})
	];
}
