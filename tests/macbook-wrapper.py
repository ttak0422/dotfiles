"""Exercise bootstrap guards without Nix, macOS, or activation."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

source = Path(__file__).resolve().parents[1] / "scripts/macbook-system"
with tempfile.TemporaryDirectory() as directory:
    root = Path(directory)
    (root / "scripts").mkdir()
    shutil.copy2(source, root / "scripts/macbook-system")
    bin_dir = root / "bin"
    bin_dir.mkdir()
    log = root / "calls"
    scripts = {
        "id": 'case "$1" in -u) echo "${TEST_UID:-501}";; -un) echo example;; esac',
        "uname": 'case "$1" in -s) echo "${TEST_OS:-Darwin}";; -m) echo arm64;; esac',
        "nix": '[ "${TEST_BUILD_FAIL:-0}" = 0 ] || exit 42; printf "%s\\n" "$*" >> "$TEST_LOG"; mkdir -p result-macbook/sw/bin; touch result-macbook/sw/bin/darwin-rebuild',
        "sudo": 'printf "sudo %s\\n" "$*" >> "$TEST_LOG"',
    }
    for name, content in scripts.items():
        path = bin_dir / name
        path.write_text("#!/bin/sh\nset -eu\n" + content + "\n")
        path.chmod(0o755)
    env = dict(os.environ, PATH=f"{bin_dir}:/usr/bin:/bin", HOME="/Users/example", TEST_LOG=str(log))

    def run(action, code=0, **overrides):
        result = subprocess.run([str(root / "scripts/macbook-system"), action], env=env | overrides,
                                text=True, capture_output=True)
        assert result.returncode == code, (result.returncode, result.stderr)

    run("invalid", 2)
    run("build", 1, TEST_UID="0")
    run("build", 1, TEST_OS="Linux")
    run("build", 1, HOME="/Users/other")
    assert not log.exists()
    run("build")
    assert "--impure" in log.read_text()
    assert "sudo " not in log.read_text()
    assert "darwinConfigurations.macbook.system" in log.read_text()
    run("switch")
    assert "sudo /usr/bin/env DOTFILES_USERNAME=example DOTFILES_HOME=/Users/example " in log.read_text()
    assert "darwin-rebuild switch --impure --no-update-lock-file --flake " in log.read_text()
    before = log.read_text()
    run("switch", 42, TEST_BUILD_FAIL="1")
    assert log.read_text() == before  # Never activate a stale successful build.
print("macbook wrapper guards and build/switch separation: passed")
