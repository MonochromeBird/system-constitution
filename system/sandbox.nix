{ lib, pkgs, utils, ... }:
rec {
	packages = with utils; [
		sandbox-exec-directory
		generate-firejail-net
		generate-firejail-args
	];

	sandbox-exec-directory = (pkgs.writeShellScriptBin "sandbox-exec-directory" (builtins.readFile ./sources/sandbox-exec-directory.sh));
	generate-firejail-net = (pkgs.writeShellScriptBin "generate-firejail-net" (builtins.readFile ./sources/generate-firejail-net.sh));

	generate-firejail-args = (pkgs.writeShellScriptBin "generate-firejail-args" ''
		printf -- "${firejail.constantArgs}"
	'');

	wrappedPriority = -3;

	setPriority = package:
		package // { meta = (package.meta // { priority = wrappedPriority; } ); };
	
	firejail = {
		constantArgs = "--blacklist=/conf";
		
		package = name: parameters:
			setPriority (pkgs.writeShellScriptBin name
				''
					PROFILE="${utils.insertIfAvailable parameters "profile"}"
					EXTRA_ARGS="${utils.insertSpacedIfAvailable parameters "extraArgs"}"
					ABORT_IF_MISSING_PROFILE="${utils.insertIfAvailable parameters "abortIfMissingProfile"}"

					if [ x$PROFILE = "x" ] || [ ! -f $PROFILE ]; then
						PROFILE_ARG=
						echo "Warning: Profile \`$PROFILE' not found."
						if [ $ABORT_IF_MISSING_PROFILE = "1" ]; then
							echo "abortIfMissingProfile is true, aborting"
							exit 2
						fi
					else
						PROFILE_ARG=--profile="$PROFILE"
					fi
					
					firejail $PROFILE_ARG $EXTRA_ARGS --quiet ${firejail.constantArgs} --name=${name} -- ${parameters.executable}\
					${utils.insertSpacedIfAvailable parameters "programArgs"} $@
				''
			);

		packages = (wrappedBinaries:
			lib.attrsets.mapAttrsToList (name: value:
				(firejail.package name value)
			) wrappedBinaries);
	};

	readParameters = parameters: {
		namespace = "";
    bin = "";

		disable = false;

		useRecommendedPreset = true;
		arguments = [ ];

		isolateNetwork = false;
		
		allowNetwork = true;
		allowCameras = false;
		allowAudio = true;
		allowHardwareAcceleration = true;
	} // parameters;

	makeParametersFromPackage = package: parameters: readParameters {
		namespace = lib.getName package;
	} // parameters;

	package = package: parameters: let
		finalParameters = makeParametersFromPackage package parameters;
	in if finalParameters.disable then package else let
		programName =
			if (lib.attrsets.hasAttrByPath [ "meta" "mainProgram" ] package)
			then package.meta.mainProgram else package.pname;
	in
		firejail.package (if finalParameters.bin != "" then finalParameters.bin else programName) {
			executable = "${package}/bin/${programName}";
			profile = if finalParameters.useRecommendedPreset then "${pkgs.firejail}/etc/firejail/${lib.getName package}.profile" else "";
			extraArgs = lib.concatLists [
				[
					"--mkdir=~/.sandbox/${finalParameters.namespace}"
					"--private=~/.sandbox/${finalParameters.namespace}"
					"--private-tmp"
				]
				
				(if finalParameters.useRecommendedPreset then [] else ["--noprofile"])
				(if finalParameters.allowCameras then [ ] else [ "--novideo" ])
				(if finalParameters.allowAudio then [ ] else [ "--nosound" ])
				(if finalParameters.allowHardwareAcceleration then [ ] else [ "--no3d" ])
				(if finalParameters.allowNetwork then [ ] else [ "--net=none" ])
				(if finalParameters.isolateNetwork then [ "$(generate-firejail-net)" ] else [ ])
			];
			abortIfMissingProfile = false;
			programArgs = finalParameters.arguments;
		};
}
