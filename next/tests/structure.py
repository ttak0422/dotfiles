"""Check the next/ boundary without evaluating Nix or changing any host."""
import json
from pathlib import Path
import re

root = Path(__file__).resolve().parents[1]
for path in root.rglob("*.nix"):
    for relative in re.findall(r"(?<![\w/])(?:\.\.?/)[\w./-]+", path.read_text()):
        target = (path.parent / relative).resolve()
        assert target.is_relative_to(root), (path, relative, "escapes next/")
        assert target.exists(), (path, relative, "missing local path")

lock = json.loads((root / "flake.lock").read_text())
nodes = lock["nodes"]
assert set(nodes["root"]["inputs"]) == {"nixpkgs", "darwin", "home-manager", "dotfiles-nvim"}


def resolve(reference):
    if isinstance(reference, str):
        assert reference in nodes, reference
        return reference
    node = lock["root"]
    for component in reference:
        node = resolve(nodes[node]["inputs"][component])
    return node


visited = set()


def visit(node):
    if node in visited:
        return
    visited.add(node)
    for reference in nodes[node].get("inputs", {}).values():
        visit(resolve(reference))


visit(lock["root"])
assert visited == set(nodes), "unreachable lock nodes"
print("next boundary, local references and lock closure: passed")
