{ ... }:
{
  system.defaults = {
    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
    };
    dock = {
      appswitcher-all-displays = true;
      autohide = true;
      launchanim = false;
      mineffect = "suck";
      mouse-over-hilite-stack = true;
      orientation = "bottom";
      show-process-indicators = true;
      show-recents = false;
      static-only = true;
    };
    NSGlobalDomain = {
      "com.apple.keyboard.fnState" = true;
      "com.apple.swipescrolldirection" = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticCapitalizationEnabled = false;
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticWindowAnimationsEnabled = false;
    };
  };
}
