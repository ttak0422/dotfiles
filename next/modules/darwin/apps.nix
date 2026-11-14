{ ... }:
{
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
      "google-chrome" # Web browser.
      "onedrive" # Cloud file synchronization.
      "chatgpt" # ChatGPT desktop client.
      "slack" # Team messaging.
      "karabiner-elements" # Keyboard remapping.
      "macskk" # SKK Japanese input method.
      "omniwm" # Tiling window manager.
    ];
  };
}
