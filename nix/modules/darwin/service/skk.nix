{ inputs, pkgs, ... }:
{
  imports = [ inputs.yaskkserv2-service.darwinModules.default ];
  services.yaskkserv2 = {
    enable = true;
    dictionary = "${pkgs.yaskkserv2-dictionary}/dictionary.yaskkserv2";
    googleSuggest = true;
  };
}
