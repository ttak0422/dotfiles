{ inputs, pkgs, ... }:
{
  imports = [ inputs.neru.darwinModules.default ];

  services.neru = {
    enable = true;
    package = inputs.neru.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings.hotkeys = {
      "Primary+Shift+Space" = "hints --action left_click";
      # Neru merges nonempty hotkey tables with its defaults.
      "Primary+Shift+G" = "__disabled__";
      "Primary+Shift+C" = "__disabled__";
      "Primary+Shift+B" = "__disabled__";
      "Primary+Shift+S" = "__disabled__";
    };
  };

  homebrew = {
    enable = true;
    enableZshIntegration = true;
    onActivation = {
      # Preserve applications installed outside this configuration.
      cleanup = "none";
      autoUpdate = false;
      upgrade = false;
    };
    casks = [
      "ghostty" # GPU-accelerated terminal emulator.
      "google-chrome" # Web browser.
      "onedrive" # Cloud file synchronization.
      "chatgpt" # ChatGPT desktop client.
      "slack" # Team messaging.
      "karabiner-elements" # Keyboard remapping.
      "macskk" # SKK Japanese input method.
      "omniwm" # Tiling window manager.
      "betterdisplay" # Display management.
      "raycast" # Application launcher.
    ];
  };
}
