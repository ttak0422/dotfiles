{
  self,
  inputs,
  withSystem,
  ...
}:
{
  flake.nixosConfigurations = withSystem "x86_64-linux" (
    {
      self',
      inputs',
      system,
      pkgs,
      ...
    }:
    let
      user = "ttak0422";
      specialArgs =
        {
          inherit system;
          inherit self;
          inherit inputs;
          inherit self';
          inherit inputs';
        }
        // pkgs.dhallToNix (builtins.readFile ./../../../host.dhall)
        // {
          inherit user;
        };
    in
    {
      laptop = inputs.nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          inputs.home-manager.nixosModules.home-manager
          ./../../modules/linux/hyprland
          ./../../modules/linux/prelude.nix
          ./../../modules/linux/service/onedrive.nix
          ./../../modules/linux/service/power.nix
          ./../../modules/linux/service/skk.nix
          ./../../modules/linux/service/xremap.nix
          ./../../modules/shared/nvim.nix
          ./../../modules/shared/prelude.nix
          {
            imports =
              [
                ./hardware-configuration.nix
              ]
              ++ (with inputs.nixos-hardware.nixosModules; [
                common-cpu-intel
                common-pc-laptop
                common-pc-laptop-ssd
              ]);

            boot = {
              kernelPackages = pkgs.linuxKernel.packages.linux_zen;
              loader.systemd-boot.enable = true;
              loader.efi.canTouchEfiVariables = true;
            };

            networking = {
              hostName = user;
              networkmanager.enable = true;
            };

            time.timeZone = "Asia/Tokyo";

            i18n = {
              inputMethod = {
                enable = true;
                type = "fcitx5";
                fcitx5.addons = with pkgs; [ fcitx5-skk ];
              };
              defaultLocale = "ja_JP.UTF-8";
              extraLocaleSettings = {
                LC_ADDRESS = "ja_JP.UTF-8";
                LC_IDENTIFICATION = "ja_JP.UTF-8";
                LC_MEASUREMENT = "ja_JP.UTF-8";
                LC_MONETARY = "ja_JP.UTF-8";
                LC_NAME = "ja_JP.UTF-8";
                LC_NUMERIC = "ja_JP.UTF-8";
                LC_PAPER = "ja_JP.UTF-8";
                LC_TELEPHONE = "ja_JP.UTF-8";
                LC_TIME = "ja_JP.UTF-8";
              };
            };

            fonts = {
              packages = with pkgs; [
                hackgen-font
                jetbrains-mono
                noto-fonts
                noto-fonts-cjk-sans
                noto-fonts-cjk-serif
                noto-fonts-color-emoji
                noto-fonts-emoji-blob-bin
                noto-fonts-monochrome-emoji
                plemoljp
                plemoljp-nf
              ];
              fontDir.enable = true;
              fontconfig = {
                defaultFonts = {
                  serif = [
                    "Noto Serif CJK JP"
                    "Noto Color Emoji"
                  ];
                  sansSerif = [
                    "Noto Sans CJK JP"
                    "Noto Color Emoji"
                  ];
                  monospace = [
                    "JetBrainsMono Nerd Font"
                    "Noto Color Emoji"
                  ];
                  emoji = [ "Noto Color Emoji" ];
                };
              };
            };
            services = {
              desktopManager.plasma6.enable = true;
              # Enable CUPS to print documents.
              printing.enable = true;
              pipewire = {
                enable = true;
                alsa.enable = true;
                alsa.support32Bit = true;
                pulse.enable = true;
                # If you want to use JACK applications, uncomment this
                #jack.enable = true;
              };
            };

            hardware.bluetooth.enable = true;
            services.blueman.enable = true;

            hardware.pulseaudio.enable = false;
            security.rtkit.enable = true;

            users.users.${user} = {
              isNormalUser = true;
              description = user;
              extraGroups = [
                "networkmanager"
                "wheel"
              ];
              shell = pkgs.zsh;
              packages = [ ];
            };
            programs.zsh.enable = true;

            # Allow unfree packages
            nixpkgs.config.allowUnfree = true;

            # Some programs need SUID wrappers, can be configured further or are
            # started in user sessions.
            # programs.mtr.enable = true;
            # programs.gnupg.agent = {
            #   enable = true;
            #   enableSSHSupport = true;
            # };

            # List services that you want to enable:

            # Enable the OpenSSH daemon.
            # services.openssh.enable = true;

            # Open ports in the firewall.
            # networking.firewall.allowedTCPPorts = [ ... ];
            # networking.firewall.allowedUDPPorts = [ ... ];
            # Or disable the firewall altogether.
            # networking.firewall.enable = false;

            # This value determines the NixOS release from which the default
            # settings for stateful data, like file locations and database versions
            # on your system were taken. It‘s perfectly fine and recommended to leave
            # this value at the release version of the first install of this system.
            # Before changing this value read the documentation for this option
            # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
            system.stateVersion = "24.11"; # Did you read the comment?

            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              backupFileExtension = "bkp";
              users.${user} = {
                imports = [
                  inputs.hyprpanel.homeManagerModules.hyprpanel
                  ./../../modules/hm-linux/apps.nix
                  ./../../modules/hm-linux/hyprland
                  ./../../modules/hm-linux/wezterm.nix
                  ./../../modules/hm/dev
                  ./../../modules/hm/git
                  ./../../modules/hm/shell
                  ./../../modules/hm/tool
                ];
                home = {
                  username = user;
                  stateVersion = "24.11";
                };
              };
              extraSpecialArgs = specialArgs;
            };
          }
        ];
      };
    }
  );
}
