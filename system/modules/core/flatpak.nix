{ pkgs, ... }:
{
  system = {
    services.flatpak.enable = true;
    
		xdg.portal = {
			enable = true;
			extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
			config.common.default = "*";
		};
  };
}
