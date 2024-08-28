{ lib, ... }:
rec {
	joinStrings = strings: separator:
		lib.concatStrings (lib.lists.forEach strings (string: (toString string) + separator));

	insertIfAvailable = set: valueName:
			if (lib.attrsets.hasAttrByPath [ valueName ] set) then
				"${toString set.${valueName}}"
			else "";
	
	insertSpacedIfAvailable = set: valueName:
			if (lib.attrsets.hasAttrByPath [ valueName ] set) then
				"${joinStrings set.${valueName} " "}"
			else "";

	mergeListsFromSets = sets: valueName: lib.concatLists (
		lib.lists.forEach sets (set: set.${valueName})
	);

	getAllFromSets = sets: valueName: lib.lists.forEach sets (
		set: set.${valueName}
	);

	setFromCSV = text:
		( lib.attrsets.mergeAttrsList (
			builtins.map (x: { "${builtins.elemAt x 0}" = builtins.elemAt x 1; }) (
				lib.lists.filter (x: lib.length x == 2) (
						lib.lists.forEach (lib.strings.splitString "\n" text) (
							line: lib.strings.splitString "," line)))));
}
