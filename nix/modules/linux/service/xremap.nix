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
      keymap = [ ];
    };
  };
}
