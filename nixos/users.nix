# users file, add urself / edit existing user 

{ pkgs, config, ... }:

{
    # don't forget to change `initialPassword` to yours!
    users = { 
        defaultUserShell = pkgs.fish;
	mutableUsers = true;
        # if FALSE you'll need to add every new users with their passwords here.
        users = {
            kotudemo = {
                description = "kotudemo aka GOIDALIZATOR BOL'SHIYE YAICA 777";
                extraGroups = [ "wheel" ]; 
                isSystemUser = false;
                isNormalUser = true;
                initialPassword = "password";
                packages = with pkgs; [
                    #discord
		            vesktop
                    telegram-desktop
                    spotify
		            spicetify-cli
		            # _64gram
		            starship
                ];
            };
        };
    };
}
