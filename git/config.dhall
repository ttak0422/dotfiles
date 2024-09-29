\(host : { name : Text, email : Text, isDarwin : Bool, configDir : Text }) ->
  ''
  [user]
    name=${host.name}
    email=${host.email}
  [core]
    autocrlf = false
    ignorecase = false
    untrackedcache = true
    fsmonitor = false
  [color]
    gi = auto
  [init]
    defaultBranch = main
  [alias]
    ignore = "!f() { curl -L -s https://www.gitignore.io/api/$@ ;}; f"
  [commit]
    template = ~/${host.configDir}/committemplate
  [rerere]
  	enabled = true
  [pager]
    diff = delta
    log = delta
    reflog = delta
    show = delta
  [filter "lfs"]
    clean = git-lfs clean -- %f
    smudge = git-lfs smudge -- %f
    process = git-lfs filter-process
    required = true
  [credential]
    helper = ${if host.isDarwin then "osxkeychain" else "store"}
  ''
