{ pkgs, ... }:
{
	packages = with pkgs; [
		dotnet-sdk_9 nuget
		omnisharp-roslyn
		netcoredbg
	];
}
