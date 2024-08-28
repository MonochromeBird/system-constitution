{ config, lib, utils, lawConfig, dynamic ? false, ... }:
let
	makeLink = filename:
		let
			prefix = lawConfig.absolutePath + "/user/niki/config/";
		in if dynamic then
			(config.lib.file.mkOutOfStoreSymlink (prefix + ("/" + filename)))
		else (./. + ("/" + filename));
in
{
	home.file = lib.attrsets.concatMapAttrs (
		n: v: { "${v}".source = makeLink n; }
	) (utils.setFromCSV (builtins.readFile ./links.csv));
}
