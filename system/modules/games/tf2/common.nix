{ lib, utils, opts, ... }:
let
	dir = {
			path = ".sandbox/steam/.local/share/Steam/steamapps/common/Team Fortress 2/tf/cfg";
			home = true;
	} // ({tf2configDir = {};} // opts).tf2configDir;

	files = utils.getFiles ./.;
in
{
	system.systemd.tmpfiles.settings = if !dir.home then
		lib.attrsets.mergeAttrsList (
			lib.lists.map (file: {
				"99-tf2-${file}"."${dir.path}/${file}".L = {
					group = "wheel";
					user = "root";
					mode = "0775";
					argument = "${./. + "/${file}"}";
				};
			}) files
		)
	else {};

	home.home.file = if dir.home then lib.attrsets.mergeAttrsList (
			lib.lists.map (file: {
				"${dir.path}/${file}".source = ./. + "/${file}";
			}) files
		)
	else {};
}
