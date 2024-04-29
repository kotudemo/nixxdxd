# Config for (my) desktop

{ config, lib, inputs, pkgs, overlays, ... }:

{
      imports = [
        # ../desktop.d/de.nix
   	    ../desktop.d/wm.nix
    ];

    environment.variables = { EDITOR = "vim"; };
    # Networking
    networking = {
        # bonds = ;
        # bridges = ;
        firewall = { 
            allowPing = true;
            # allowedTCPPorts = [ ... ];
            # allowedTCPPortRanges = [ 
                # { from = ...; to = ...; }
            # ];
            # allowedUDPPorts = [ ... ]; 
            # allowedUDPPortRanges = [ 
                # { from = ...; to = ...; }
            # ];
            enable = true;
        };
        hostName = "goidapc";
        networkmanager = {
            enable = true;
        };
        # proxy = {
            # allProxy = ;
            # default = ;
            # ftpProxy = ;
            # httpProxy = ;
            # httpsProxy = ;
            # noProxy = ;
            # rsyncProxy = ;

        # };
        wireless = {
            enable = false;
        };
    };  


    # Packages
    nixpkgs = {
    	config.allowUnfree = true;
      config.permittedInsecurePackages = ["python-2.7.18.8" ];
    };
    programs.bash = {
 	 interactiveShellInit = ''
    		if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    		then
      			shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
      			exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    		fi
  	'';
};
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
        shellAliases = {
      	    cl = "clear";
            si = "swayimg";
            ls = "eza -aG --color=always";
      	    pf = "clear && nix run nixpkgs#pfetch";
	        ff = "clear && nix run nixpkgs#fastfetch";
	        nf = "clear && nix run nixpkgs#neofetch";
	        btop = "clear && nix run nixpkgs#btop";
	        nsp = "nix-shell -p";
	        ncg = "nix store gc -v && nix-collect-garbage --delete-old";
	        update = "cd /etc/nixos && sudo nixos-rebuild switch --upgrade --flake .#kotudemo && cd";
        };
    };
    environment = {
        systemPackages = with pkgs; [
            helix
            vscodium
	        foot
	        eza
	        fish
	        wofi
	        xarchiver
            home-manager
#	    gutenprint
	        swaybg
         rofi
	        git
	        unrar
            google-cursor
	        zip
	        unzip
	        obs-studio
	        slurp
	        obsidian
	        mpv
	        gparted
	        grim
            swayimg
             pywal           
             swww
	        xwayland
	        wl-clipboard
	        waybar
	        libnotify
	        cinnamon.nemo-with-extensions
	        cups
	        canon-cups-ufr2
	        cups-filters
            polkit
            polkit_gnome
            python3Full
            nodejs
            python.pkgs.pip
            wlsunset
            glib
            gcc
            gnumake
            mako
            file
            hyprcursor
            xdg-desktop-portal-hyprland
            socat
            jq
            gtk3
            lxappearance-gtk2
            papirus-icon-theme
            gnome.gnome-calendar
            (catppuccin-gtk.override {
    		    accents = [ "sapphire" ]; 
    		    size = "compact";
    		    tweaks = [ "rimless" "black" ];     
		        variant = "mocha";
  	        })
    ];
   
        # gnome.excludePackages = with pkgs.gnome; [ ];
        # plasma5.excludePackages = with pkgs.libsForQt5; [ ];
        # plasma5.excludePackages = with pkgs.kdePackages; [ ];
    };
    fonts.packages = with pkgs; [
        hack-font
	    noto-fonts
	    noto-fonts-emoji
	    twemoji-color-font
	    font-awesome
	    jetbrains-mono
	    powerline-fonts
        powerline-symbols
        nerdfonts
    ];

    # Keeb and smth like it
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
        enable = true;
        font = "HackRegular-16";
        keyMap = "us";
        # packages = [ ... ];
        useXkbConfig = false;  
    };


    # Services
    hardware.printers = {
  ensureDefaultPrinter = "Canon_MF3010";
  ensurePrinters = [
    {
       name = "Canon_MF3010";
       location = "Home";
       deviceUri = "usb://Canon/MF3010?serial=016890000153&interface=1";
       model = "CNRCUPSMF3010ZS.ppd";
       ppdOptions = {
         PageSize = "A4";
       };
     }
   ];
 };
     hardware.pulseaudio.enable = false;  
     sound.enable = true;
    systemd = {
       user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
   # wantedBy = [ "graphical-session.target" ];
   # wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
      };
    };
};
     security = { 
        polkit.enable = true; 
        rtkit.enable = true;
     };

     services = {
            desktopManager = {
            plasma6.enable = true;         # toggle for KDE Plasma 6
        };
	    gvfs.enable = true;
        udisks2.enable = true;
	    automatic-timezoned.enable = true;
        avahi = {
            enable = true;
            nssmdns4 = false;
            openFirewall = false;
        };
        xserver = {
            enable = true;
	        displayManager = {
                gdm.enable = false;
                lightdm.enable = false;
                startx.enable = false;
                xpra.enable = false;
        };
            xkb = {
                layout = "us,ru";
	            variant = "qwerty";
	            options = "grp:shift_alt_toggle"; };
            videoDrivers = ["nvidia"];
            windowManager = {
                awesome.enable = false;
                bspwm.enable = false;
                dwm.enable = false;
                evilwm.enable = false;
                exwm.enable = false;
                herbstluftwm.enable = false;
                hypr.enable = false;
                i3.enable = false;
                icewm.enable = false;
                leftwm.enable = false;
                lwm.enable = false;
                openbox.enable = false;
                qtile.enable = false;
                ragnarwm.enable = false;
                smallwm.enable = false;
                spectrwm.enable = false;
                stumpwm.enable = false;
                tinywm.enable = false;
                xmonad.enable = false;
            };
        };

        displayManager = {
            sddm.enable = true;        
            autoLogin.enable = false;
        };
        pipewire = {
	        enable = true;
	        audio.enable = true;
	        pulse.enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
	};	
	printing = {
            enable = true;
            drivers = with pkgs; [ canon-cups-ufr2 cups-filters ];
	};
    };
}
