{  lib, pkgs, ...}: 
let
  inherit (lib) concatStringsSep escapeShellArg mapAttrsToList;
  env = {
    MOZ_ENABLE_WAYLAND = 1;
    MOZ_WEBRENDER = 1;
    GTK_USE_PORTAL= 1;
    # For a better scrolling implementation and touch support.
    # Be sure to also disable "Use smooth scrolling" in about:preferences
    MOZ_USE_XINPUT2 = "1";
    # Required for hardware video decoding.
    # See https://github.com/elFarto/nvidia-vaapi-driver?tab=readme-ov-file#firefox
    #MOZ_DISABLE_RDD_SANDBOX = 1;
    #LIBVA_DRIVER_NAME = "nvidia";
    #NVD_BACKEND = "direct";
  };
  envStr = concatStringsSep " " (mapAttrsToList (n: v: "${n}=${escapeShellArg v}") env);

  userjs = pkgs.fetchFromGitHub {
	  owner = "kotudemo";
	  repo = "user.js";
	  rev =  "0a36db4bcc9ce4ecb0eff90d72a4704160e3ad20";
	  #rev = "v${version}";
	  hash =  "sha1-2pOvgU1Ng9iyt81XKdLRcRcGzgE=";
  };
  in {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.overrideAttrs (old: {
      buildCommand =
        old.buildCommand
        + ''
          substituteInPlace $out/bin/firefox \
            --replace "exec -a" ${escapeShellArg envStr}" exec -a"
        '';
    });

    profiles.default = {
      id = 0;
      isDefault = true;

      userChrome = ''
      	{
	--animation-speed: 0.2s;
 	--button-corner-rounding: 30px;
  	--urlbar-container-height: 40px !important;
  	--urlbar-min-height: 30px !important;
  	--urlbar-height: 30px !important;
  	--urlbar-toolbar-height: 38px !important;
  	--moz-hidden-unscrollable: scroll !important;
  	--toolbarbutton-border-radius: 3px !important;
  	--tabs-border-color: transparent;
	}

	:root {
  	 --window: -moz-Dialog !important;
   	 --secondary: color-mix(in srgb, currentColor 5%, -moz-Dialog) !important;
   	 --uc-border-radius: 0px;
    	 --uc-status-panel-spacing: 0px;
   	 --uc-page-action-margin: 7px;
	}

	#nav-bar:not([customizing]) {
  visibility: visible;
  margin-top: -40px;
  transition-delay: 0.1s;
  filter: alpha(opacity=0);
  opacity: 0;
  transition: visibility, ease 0.1s, margin-top, ease 0.1s, opacity, ease 0.1s,
  rotate, ease 0.1s !important;
}

#nav-bar:hover,
#nav-bar:focus-within,
#urlbar[focused='true'],
#identity-box[open='true'],
#titlebar:hover + #nav-bar:not([customizing]),
#toolbar-menubar:not([inactive='true']) ~ #nav-bar:not([customizing]) {
  visibility: visible;

  margin-top: 0px;
  filter: alpha(opacity=100);
  opacity: 100;
  margin-bottom: -0.2px;
}
#PersonalToolbar {
  margin-top: 0px;
}
#nav-bar .toolbarbutton-1[open='true'] {
  visibility: visible;
  opacity: 100;
}

:root:not([customizing]) :hover > .tabbrowser-tab:not(:hover) {
  transition: blur, ease 0.1s !important;
}

:root:not([customizing]) :not(:hover) > .tabbrowser-tab {
  transition: blur, ease 0.1s !important;
}

#tabbrowser-tabs .tab-label-container[customizing] {
  color: transparent;
  transition: ease 0.1s;
  transition-delay: 0.1s;
}
/*
.tabbrowser-tab:not([pinned]) .tab-icon-image ,.bookmark-item .toolbarbutton-icon{opacity: 0!important; transition: .15s !important; width: 0!important; padding-left: 16px!important}
.tabbrowser-tab:not([pinned]):hover .tab-icon-image,.bookmark-item:hover .toolbarbutton-icon{opacity: 100!important; transition: .15s !important; display: inline-block!important; width: 16px!important; padding-left: 0!important}
.tabbrowser-tab:not([hover]) .tab-icon-image,.bookmark-item:not([hover]) .toolbarbutton-icon{padding-left: 0!important}
*/
/*  Removes annoying buttons and spaces */
.titlebar-spacer[type="pre-tabs"], .titlebar-spacer[type="post-tabs"]{display: none !important}
#tabbrowser-tabs{border-inline-start-width: 0!important}

/*  Makes some buttons nicer  */
#PanelUI-menu-button, #unified-extensions-button, #reload-button, #stop-button {padding: 2px !important}
#reload-button, #stop-button{margin: 1px !important;}

/* X-button */
:root {
    --show-tab-close-button: none;
    --show-tab-close-button-hover: -moz-inline-block;
}
.tabbrowser-tab:not([pinned]) .tab-close-button { display: var(--show-tab-close-button) !important; }
.tabbrowser-tab:not([pinned]):hover .tab-close-button { display: var(--show-tab-close-button-hover) !important }

/* tabbar */

/* Hide the secondary Tab Label
 * e.g. playing indicator (the text, not the icon) */
.tab-secondary-label { display: none !important; }

:root {
  --toolbarbutton-border-radius: 0 !important;
  --tab-border-radius: 0 !important;
  --tab-block-margin: 0 !important;
}

.tabbrowser-tab:is([visuallyselected='true'], [multiselected])
  > .tab-stack
  > .tab-background {
  box-shadow: none !important;
}

.tab-background {
  border-right: 0px solid rgba(0, 0, 0, 0) !important;
  margin-left: -1px !important;
}

.tabbrowser-tab[last-visible-tab='true'] {
  padding-inline-end: 0 !important;
}

#tabs-newtab-button {
  padding-left: 0 !important;
}

/* multi tab selection */
#tabbrowser-tabs:not([noshadowfortests]) .tabbrowser-tab:is([multiselected])
  > .tab-stack
  > .tab-background:-moz-lwtheme { outline-color: var(--toolbarseparator-color) !important; }

/* remove gap after pinned tabs */
#tabbrowser-tabs[haspinnedtabs]:not([positionpinnedtabs])
  > #tabbrowser-arrowscrollbox
  > .tabbrowser-tab:nth-child(1 of :not([pinned], [hidden])) { margin-inline-start: 0 !important; }

/*  Removes annoying border  */
#navigator-toolbox{border:none !important;}

/*  Removes the annoying rainbow thing from the hamburger  */
#appMenu-fxa-separator{border-image:none !important;}

      '';

      extraConfig = builtins.concatStringsSep "\n" [
        (builtins.readFile "${userjs}/user.js")
      ];

      settings = {
        # General
        "intl.accept_languages" = "en-US,en";
        "browser.startup.page" = 3; # Resume previous session on startup
        "browser.aboutConfig.showWarning" = false; # I sometimes know what I'm doing
        "browser.ctrlTab.sortByRecentlyUsed" = true; # (default) Who wants that?
        "browser.download.useDownloadDir" = false; # Ask where to save stuff
        "browser.translations.neverTranslateLanguages" = "ru"; # No need :)
        "privacy.clearOnShutdown.history" = false; # We want to save history on exit
        # Hi-DPI
        "layout.css.devPixelsPerPx" = "1.0";
        # Allow executing JS in the dev console
        "devtools.chrome.enabled" = true;
        # Disable browser crash reporting
        "browser.tabs.crashReporting.sendReport" = false;
        # Allow userCrome.css
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        # Why the fuck can my search window make bell sounds
        "accessibility.typeaheadfind.enablesound" = false;
        # Why the fuck can my search window make bell sounds
        "general.autoScroll" = true;

        # Hardware acceleration
        # See https://github.com/elFarto/nvidia-vaapi-driver?tab=readme-ov-file#firefox
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
        "widget.dmabuf.force-enabled" = true;
        "media.av1.enabled" = false; # XXX: change once I've upgraded my GPU
        # XXX: what is this?
        "media.ffvpx.enabled" = false;
        "media.rdd-vpx.enabled" = false;

        # Privacy
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.userContext.enabled" = true;
        "privacy.userContext.ui.enabled" = true;

        "browser.send_pings" = false; # (default) Don't respect <a ping=...>

        # This allows firefox devs changing options for a small amount of users to test out stuff.
        # Not with me please ...
        "app.normandy.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;

        "beacon.enabled" = false; # No bluetooth location BS in my webbrowser please
        "device.sensors.enabled" = false; # This isn't a phone
        "geo.enabled" = false; # Disable geolocation alltogether

        # ESNI is deprecated ECH is recommended
        "network.dns.echconfig.enabled" = true;

        # Disable telemetry for privacy reasons
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.enabled" = false; # enforced by nixos
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.unified" = false;
        "extensions.webcompat-reporter.enabled" = false; # don't report compability problems to mozilla
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.urlbar.eventTelemetry.enabled" = false; # (default)

        # Disable some useless stuff
        "extensions.pocket.enabled" = false; # disable pocket, save links, send tabs
        "extensions.abuseReport.enabled" = false; # don't show 'report abuse' in extensions
        "extensions.formautofill.creditCards.enabled" = false; # don't auto-fill credit card information
        "identity.fxaccounts.enabled" = false; # disable firefox login
        "identity.fxaccounts.toolbar.enabled" = false;
        "identity.fxaccounts.pairing.enabled" = false;
        "identity.fxaccounts.commands.enabled" = false;
        "browser.contentblocking.report.lockwise.enabled" = false; # don't use firefox password manger
        "browser.uitour.enabled" = false; # no tutorial please
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

        # disable EME encrypted media extension (Providers can get DRM
        # through this if they include a decryption black-box program)
        "browser.eme.ui.enabled" = false;
        "media.eme.enabled" = false;

        # don't predict network requests
        "network.predictor.enabled" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;

        # disable annoying web features
        "dom.push.enabled" = false; # no notifications, really...
        "dom.push.connection.enabled" = false;
        "dom.battery.enabled" = false; # you don't need to see my battery...
      };

      search = {
        force = true;
        default = "DuckDuckGo";
        order = [ "DuckDuckGo" "Google" "Youtube" "NixOS Options" "Nix Packages" "GitHub" ];

        engines = {
          "Bing".metaData.hidden = true;
          "Amazon.com".metaData.hidden = true;
          "Google".metaData.hidden = true;

          "YouTube" = {
            iconUpdateURL = "https://youtube.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = ["@yt"];
            urls = [
              {
                template = "https://www.youtube.com/results";
                params = [
                  {
                    name = "search_query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };

          "Nix Packages" = {
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };

          "NixOS Options" = {
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@no"];
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };

          "GitHub" = {
            iconUpdateURL = "https://github.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = ["@gh"];

            urls = [
              {
                template = "https://github.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };

        };
      };
    };
  };

#  home.persistence."/state".directories = [
#    ".cache/mozilla"
#  ];

 # home.persistence."/persist".directories = [
 #   ".mozilla"
 # ];

  xdg.mimeApps.defaultApplications = {
    "text/html" = ["firefox.desktop"];
    "text/xml" = ["firefox.desktop"];
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
  };
}
