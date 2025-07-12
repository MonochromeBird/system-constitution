{ pkgs, system, ... }:
{
	packages = with pkgs; [
    (import (pkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "30e2e2857ba47844aa71991daa6ed1fc678bcbb7";
      sha256 = "1hw4ccgwzi120j41xr8k8njsxk74l0ciir1g93mij1p43cmrgccj";
    }) { inherit system; }).dotnet-sdk_10

		nuget
		omnisharp-roslyn
		netcoredbg
	];
}
