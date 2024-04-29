# wm and wayland comositors options
{ config, pkgs, ... }:
{
    programs.hyprland = {
    	enable = true;
	    xwayland.enable = true;
    };

    environment.sessionVariables = {
	    WLR_NO_HARDWARE_CURSORS = "1";
	    NIXOS_OZONE_WL = "1";
    };
   
    hardware = {
      bluetooth = { 
        enable = true; 
        powerOnBoot = true; };
	    opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;   
      };
	    nvidia = {
        modesetting.enable = true;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        powerManagement = {
            enable = false;
            finegrained = false;
        };
      };
    };
}
