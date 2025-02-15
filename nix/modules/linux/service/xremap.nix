{ username, inputs, ... }:
{
  imports = [ inputs.xremap.nixosModules.default ];
  services.xremap = {
    userName = username;
    serviceMode = "user";
    config = {
      modmap = [
        {
          name = "CapsLock → Ctrl";
          remap = {
            CapsLock = "Ctrl_L";
          };
        }
      ];
      keymap = [
        {
          # WIP
          name = "emacs like keymap";
          exact_match = true;
          application = {
            only = [
              "zen"
              "Zen Browser"
            ];
          };
          remap = {
            C-a = "Home";
            C-e = "End";
          };
        }
      ];
    };
  };
}
