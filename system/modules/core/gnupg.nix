{ pkgs, ... }:
{
	packages = with pkgs; [
		gnupg
		pass
		pinentry-gtk2
	];

	home.home.file.".gnupg/gpg-agent.conf".text =
		"pinentry-program /run/current-system/sw/bin/pinentry";
}
