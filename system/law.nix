args@{
	config,
	lib,
	pkgs,
	pkgs-stable,
	pkgs-unstable,
	nur-modules,
	lawConfig ? import ./../config.nix {},
	systemPath ? ./.,
	userPath ? ./../user,
	...
}: let
	utils = import ./utils.nix args;
	sandbox = import ./sandbox.nix (args // { utils = utils; });

	# Law must be pass itself as an argument when importing modules.
	law = rec {
		globalHome = {
			_file = __curPos.file;
			home.stateVersion = lib.mkDefault lawConfig.home.stateVersion;
		};

		globalUser = {
			isNormalUser = lib.mkDefault true;
			isSystemUser = lib.mkDefault false;
			ignoreShellProgramCheck = lib.mkDefault true;
		};

		administratorByDefault = true;
		administratorGroups = [ "wheel" ];

		allArgs = args // {
			inherit law utils sandbox;
		};

		config = lawConfig;

		# read* functions merge attribute sets with a set of defaults for
		# optional values.
		readLawModule = lawModule: (lib.attrsets.mergeAttrsList [
			{
				imports = [ ];
				lawModules = [ ];
				systemUsers = [ ];
				users = [ ];
				groups = [ ];
				system = { };
				home = { };
				packages = [ ];
				allowedUnfree = [ ];
			}

			lawModule
		]);

		readLawUser = lawUser: (lib.attrsets.mergeAttrsList [
			{
				imports = [];
				lawModules = [ ];
				allowedUnfree = [ ];
				groups = [ ];
				user = { };
				name = "";
				shell = pkgs.bash;
				home = { };
				system = {};
				packages = [ ];
				isAdministrator = administratorByDefault;
			}

			lawUser
		]);

		# user as in config.users.users.x
		readUser = user: (lib.attrsets.mergeAttrsList [
			{
				packages = [ ];
				extraGroups = [ ];
			}

			user
		]);

		readLawModuleOptions = opts: lib.attrsets.mergeAttrsList [
			{
				sandbox = {};
			}

			opts
		];

		lawModulePathToSet = lawModulePath:
			lawModulePathToSetWithOpts lawModulePath {};

		lawModulePathToSetWithOpts = lawModulePath: opts:
			(readLawModule (import lawModulePath (allArgs // { opts = readLawModuleOptions opts; }))) // { _file = lawModulePath; };

		lawModuleIdToSet = lawModuleId:
			if (builtins.typeOf lawModuleId) == "path" then
				(lawModuleIdToSetWithOpts lawModuleId {})
			else lawModuleId;

		lawModuleIdToSetWithOpts = lawModuleId: opts:
			lawModulePathToSetWithOpts (systemPath + "/modules" + lawModuleId + ".nix") opts;

		# Alias for convenience.
		overrideModule = lawModuleIdToSetWithOpts;

		importLawModule = lawModule: [ (lawModule // { system = lawModule.system // { _file = lawModule._file; };}) ]
			++ (importLawModulesById lawModule.lawModules)
			++ lib.concatLists (
				lib.lists.forEach lawModule.imports
				(
					path: importLawModule (lawModulePathToSet path)
				)
			);

		importLawModuleById = lawModuleId:
			importLawModule (lawModuleIdToSet lawModuleId);

		importLawModulesById = lawModuleIds: lib.concatLists (lib.lists.forEach lawModuleIds (
			lawModuleId: importLawModuleById lawModuleId
		));

		importLawModuleByPath = lawModulePath:
			importLawModule (lawModulePathToSet lawModulePath);

		importLawModulesByPath = lawModulePaths: lib.concatLists (lib.lists.forEach lawModulePaths (
			lawModulePath: importLawModuleByPath lawModulePath
		));

		lawUserPathToSet = lawUserPath:
			(readLawUser (import lawUserPath allArgs)) // { _file = lawUserPath; };

		lawUserIdToSet = lawUserId:
			lawUserPathToSet (userPath + ("/" + lawUserId) + "/user.nix");
		
		importLawUser = lawUser: [ lawUser ]
			++ lib.concatLists (lib.lists.forEach lawUser.imports (
				path: importLawUser (lawUserPathToSet path)
			));

		importLawUserById = lawUserId:
			importLawUser (lawUserIdToSet lawUserId);

		importLawUsersById = lawUserIds: lib.concatLists (lib.lists.forEach lawUserIds (
			lawUserId: importLawUserById lawUserId
		));

		importLawUserByPath = lawUserPath:
			importLawUser (lawUserPathToSet lawUserPath);

		importLawUsersByPath = lawUserPaths: lib.concatLists (lib.lists.forEach lawUserPaths (
			lawUserPath: importLawUserByPath lawUserPath
		));

		makeSystemModule = lawModules: {
			allowedUnfree = utils.mergeListsFromSets lawModules "allowedUnfree";
			environment.systemPackages = utils.mergeListsFromSets lawModules "packages";

			imports = lib.concatLists [
				(utils.getAllFromSets lawModules "system")

				(lib.lists.forEach (utils.mergeListsFromSets lawModules "systemUsers") (
					lawUserId:  (makeSystemUserModule (importLawUserById lawUserId))
				))

				(lib.lists.forEach (utils.mergeListsFromSets lawModules "users") (
					lawUserId:  (makeUserModule (importLawUserById lawUserId))
				))
			];
		};

		makeSystemModulesByPath = lawModulePaths:
			makeSystemModule (importLawModulesByPath lawModulePaths);

		makeSystemModulesById = lawModuleIds:
			makeSystemModule (importLawModulesById lawModuleIds);

		makeUserModule = lawUsers: let
			unifiedLawUser = lib.attrsets.mergeAttrsList lawUsers;
		in {
			imports = [{
				_file = unifiedLawUser._file;
				users.users.${unifiedLawUser.username} = globalUser // {
					extraGroups = if unifiedLawUser.isAdministrator then administratorGroups else [ ];
					description = lib.mkDefault unifiedLawUser.name;
					shell = lib.mkOverride 999 unifiedLawUser.shell;
				};

				home-manager.users.${unifiedLawUser.username}.imports = [ globalHome ];

			}] ++ (lib.lists.forEach lawUsers (
				lawUser: let 
					user = readUser lawUser.user;
					lawModules = importLawModulesById lawUser.lawModules;
				in {
					_file = lawUser._file;

					allowedUnfree = (utils.mergeListsFromSets lawModules "allowedUnfree") ++ lawUser.allowedUnfree;

					users.users.${unifiedLawUser.username} = lib.attrsets.mergeAttrsList [
						lawUser.user
						{
							extraGroups = lib.concatLists [
								(utils.mergeListsFromSets lawModules "groups")
								lawUser.groups
								user.extraGroups
							];

							packages = lib.concatLists [
								(utils.mergeListsFromSets lawModules "packages")
								lawUser.packages
								user.packages
							];
						}
					];

					home-manager.users.${unifiedLawUser.username}.imports = [
						lawUser.home
					] ++ (utils.getAllFromSets lawModules "home");
				}
			));
		};

		makeSystemUserModule = lawUsers: {
			imports = [
				(makeUserModule lawUsers)
			] ++ (lib.lists.forEach lawUsers (lawUser: lawUser.system)) ++ (lib.lists.forEach lawUsers (lawUser:
				makeSystemModulesById lawUser.lawModules
			));
		};
	};
in law
