{ pkgs, ... }:
{
	packages = with pkgs; [
		godot_4
		(pkgs.callPackage ./godot-mono-derivation.nix {})
	];
}
