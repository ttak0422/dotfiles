{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      # Preserve applications installed outside this configuration.
      cleanup = "none";
      autoUpdate = false;
      upgrade = false;
    };
    casks = [
      # Web browser.
      "google-chrome"
      # Cloud file synchronization.
      "onedrive"
      # ChatGPT desktop client.
      "chatgpt"
      # Team messaging.
      "slack"
      # Keyboard remapping.
      "karabiner-elements"
      # SKK Japanese input method.
      "macskk"
    ];
  };
}
