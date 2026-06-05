#!/bin/bash
# 更新 candao-skill 到最新版本

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_SKILLS="$HOME/.claude/skills"
QODER_SKILLS="$HOME/.qoder/skills"

echo "正在从远程拉取最新版本..."
git -C "$REPO_DIR" pull

SKILLS=("showdoc-gen-md" "showdoc-md-upload" "showdoc-publish")

update_skill() {
  local target_dir="$1"
  local label="$2"

  if [ ! -d "$target_dir" ]; then
    echo "跳过 $label（目录不存在）"
    return
  fi

  for skill in "${SKILLS[@]}"; do
    src="$REPO_DIR/$skill"
    dest="$target_dir/$skill"
    if [ -d "$src" ] && [ -d "$dest" ]; then
      # 保留 config.json（含用户密码），只更新 SKILL.md 和其他非配置文件
      rsync -a --exclude='config.json' "$src/" "$dest/"
      echo "  ✓ $skill → $label"
    fi
  done
}

echo ""
echo "更新 Claude skills..."
update_skill "$CLAUDE_SKILLS" "Claude"

echo ""
echo "更新 Qoder skills..."
update_skill "$QODER_SKILLS" "Qoder"

echo ""
echo "完成。config.json 已保留（密码未被覆盖）。"
