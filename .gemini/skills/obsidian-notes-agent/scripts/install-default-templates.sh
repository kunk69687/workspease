#!/usr/bin/env bash
set -e

# 用法：
# 在 Obsidian Vault 根目录执行：
# bash /path/to/obsidian-notes-agent/scripts/install-default-templates.sh /path/to/obsidian-notes-agent

SKILL_DIR="$1"

if [ -z "$SKILL_DIR" ]; then
  echo "Usage: $0 /path/to/obsidian-notes-agent"
  exit 1
fi

mkdir -p System/Templates

for f in "$SKILL_DIR"/templates/*.md; do
  name="$(basename "$f")"
  target="System/Templates/$name"
  if [ -e "$target" ]; then
    echo "Skip existing template: $target"
  else
    cp "$f" "$target"
    echo "Installed template: $target"
  fi
done

echo "Template installation finished. Existing templates were not overwritten."
