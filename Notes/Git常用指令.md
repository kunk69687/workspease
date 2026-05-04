# Git 常用指令手册

这份手册记录了您在同步 GitHub 时最常用的指令。

## 1. 核心同步流程（每天都要用）

### **把本地修改上传到 GitHub**
1. `git add .`  
   *将所有改动的文件放入“暂存区”（准备装箱）*
2. `git commit -m "描述你的改动"`  
   *正式保存改动（封箱并贴标签）*
3. `git push`  
   *把改动推送到云端（发货）*

### **把云端改动下载到本地**
- `git pull`  
  *从 GitHub 下载并合并最新的改动（收货）*

---

## 2. 救急指令（出问题时看）

### **找回误删的文件**
- `git checkout .`  
  *撤销本地未提交的修改，从备份中恢复文件*

### **查看当前状态**
- `git status`  
  *看看哪些文件改了、哪些还没装箱、是否领先云端*

### **查看历史记录**
- `git log --oneline`  
  *用简洁的一行形式查看之前的提交记录*

---

## 3. 常见词汇解释
- **Origin**: 远程仓库的代称（通常指 GitHub）。
- **Main/Master**: 默认的主分支。
---

## 4. 多电脑协同（在新电脑上设置）

### **第一次同步到新电脑**
1. 在新电脑上安装 Git。
2. 运行克隆命令：
   `git clone https://github.com/kunk69687/workspease.git`
   *(当提示输入密码时，请使用您的 **Access Token**)*

### **设置身份（只需执行一次）**
- `git config --global user.name "kun"`
- `git config --global user.email "kunk69687@gmail.com"`

### **让 Git 记住令牌（不用每次输密码）**
- `git config --global credential.helper store`

### **两台电脑切换时的日常流程**
1. **开工前**：先 `git pull`（接棒：获取另一台电脑的最新改动）。
2. **完工后**：`git add .` -> `git commit -m "..." ` -> `git push`（传棒：把改动传回云端）。
