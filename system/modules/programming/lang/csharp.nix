{ pkgs, ... }:
{
	packages = with pkgs; [
		dotnet-sdk_8 nuget
		omnisharp-roslyn
		netcoredbg
	];
}
