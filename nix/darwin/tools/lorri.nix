{ config, pkgs, lib, ... }: {
  environment.systemPackages = [ pkgs.lorri ];
  launchd.user.agents.lorri = {
    serviceConfig = {
      WorkingDirectory = (builtins.getEnv "HOME");
      EnvironmentVariables = { };
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/var/tmp/lorri.log";
      StandardErrorPath = "/var/tmp/lorri.log";
    };
    script = ''
      source ${config.system.build.setEnvironment}
      exec ${pkgs.lorri}/bin/lorri daemon
    '';
  };
}
