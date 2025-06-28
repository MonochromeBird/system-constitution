{ pkgs, ... }:
{
	packages = with pkgs; [
		dotnet-sdk_10 nuget
		omnisharp-roslyn
		netcoredbg
	];
}
