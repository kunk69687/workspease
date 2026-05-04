# Obsidian AI Notes Skill

这是一个用于 AI Agent / Skills 系统的 Obsidian 笔记整理 Skill。

目标：让 AI 帮助用户把零散内容整理为 Obsidian 笔记库中的正式笔记，并自动维护项目主页、双链、index 和 log。

## 推荐安装方式

把整个文件夹复制到你的 Agent Skills 目录，例如：

```text
skills/
└─ obsidian-notes-agent/
   ├─ SKILL.md
   ├─ templates/
   ├─ examples/
   └─ scripts/
```

然后在 Agent 中启用或调用这个 Skill。

## 适用的 Obsidian Vault 结构

```text
ObsidianVault/
├─ Inbox/
├─ Notes/
├─ Projects/
└─ System/
   ├─ Templates/
   ├─ AGENTS.md
   ├─ SKILL.md
   ├─ index.md
   ├─ log.md
   └─ review_queue.md
```

## Skill 能做什么

- 整理操作记录
- 整理问题排错记录
- 整理工具资源清单
- 整理学习笔记
- 更新项目主页
- 建立 Obsidian 双链
- 维护 `System/index.md`
- 维护 `System/log.md`
- 记录待确认事项到 `System/review_queue.md`

## 模板说明

Skill 自带的 `templates/` 只作为默认模板、初始化模板和兜底模板。

实际运行时，AI 必须优先使用 Obsidian Vault 中的模板：

```text
ObsidianVault/System/Templates/
```

只有当 Vault 中没有对应模板时，才允许使用 Skill 自带模板：

```text
obsidian-notes-agent/templates/
```

如果用户修改了 Vault 内的模板，后续新建笔记必须以 Vault 内模板为准。除非用户明确要求“重置模板”或“更新模板”，否则不要用 Skill 自带模板覆盖 Vault 中已有模板。

## index.md 说明

`System/index.md` 不应该只列文件名。每一条索引都必须使用：

```markdown
- [[笔记名]]：一句话说明这个笔记的内容。
```

这样 AI 建立双链时，可以先读取 `System/index.md`，根据笔记名和说明快速判断哪些笔记需要关联。

## 使用示例

```text
这是 AI工具链搭建 项目的笔记，帮我整理进去：
OpenClaw Gateway 默认只能 127.0.0.1 访问，远程访问需要 SSH 端口转发。
```

AI 应执行：

1. 读取 `System/index.md`
2. 根据 index 中的“笔记名 + 一句话说明”判断可链接笔记
3. 优先读取 `System/Templates/操作记录模板.md`
4. 创建或更新 `Notes/OpenClaw Gateway远程访问.md`
5. 更新 `Projects/AI工具链搭建/AI工具链搭建.md`
6. 建立相关双链
7. 更新 `System/index.md`
8. 追加 `System/log.md`
9. 执行 Git 同步
