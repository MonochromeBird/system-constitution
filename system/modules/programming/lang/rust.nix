{ pkgs, pkgs-stable, ... }:
{
	packages = with pkgs-stable; [
		rustc cargo
    rustup
		rust-analyzer
	];
}
