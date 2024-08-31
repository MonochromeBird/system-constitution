{ pkgs, ... }:
{
	packages = with pkgs; [
		gnupg
		(pass.withExtensions (exts: [ exts.pass-otp ]))
		pinentry-gtk2
	];

	home.home.file.".gnupg/gpg-agent.conf".text =
		"pinentry-program /run/current-system/sw/bin/pinentry";
}
