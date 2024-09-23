{
  username,
  email,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;
    userName = username;
    userEmail = email;
  };
  home.packages = with pkgs; [
    ghq
    pre-commit
    gh
  ];
}
