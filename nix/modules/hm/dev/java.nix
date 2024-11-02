{ pkgs, ... }:
let
  default = pkgs.jdk;
in
{
  home = {
    packages = with pkgs; [
      default
      gradle
      maven
    ];
    sessionVariables = {
      JAVA_HOME = "${default}";
    };
  };
}
