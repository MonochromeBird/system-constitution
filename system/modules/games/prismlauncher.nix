{ pkgs, sandbox, opts, ... }:
{
	packages = [
		(sandbox.package pkgs.prismlauncher opts.sandbox)
	];

	system = {
		programs.nix-ld.libraries = with pkgs; [
			xorg.libX11
			xorg.libXcursor
			xorg.libXext
			xorg.libXrender
			xorg.libXtst
			xorg.libXi
		];
	};
}
