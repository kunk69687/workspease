# OpenClaw 安装教程笔记

OpenClaw 存在两个截然不同的项目。根据你的需求，请选择对应的安装指南：

---

## 1. OpenClaw AI 智能体框架 (AI Agent Framework)
这是一个用于构建自主 AI 助手的开源框架，可以运行在自己的硬件或 VPS 上。

### 前提条件
*   **Node.js:** 推荐版本 24 (支持 22.14+)。
*   **API 密钥:** 需要 Anthropic (Claude), OpenAI (GPT) 或 Google (Gemini) 的 API Key。
*   **操作系统:** macOS, Linux 或 Windows (强烈推荐使用 WSL2)。

### 安装步骤
1.  **快速安装 (macOS / Linux / WSL2):**
    打开终端并运行以下安装脚本：
    ```bash
    curl -fsSL https://openclaw.ai/install.sh | bash
    ```
2.  **配置与初始化:**
    安装完成后，启动设置向导来配置 AI 模型和网关：
    ```bash
    openclaw onboard --install-daemon
    ```
3.  **验证安装:**
    检查网关是否正常运行（默认端口为 `18789`）：
    ```bash
    openclaw gateway status
    ```
4.  **访问控制面板:**
    打开 Web UI 进行交互：
    ```bash
    openclaw dashboard
    ```

---

## 2. OpenClaw 游戏引擎 (Captain Claw Reimplementation)
这是 1997 年经典平台游戏《虎胆妙探》(Captain Claw) 的现代 C++ 重构版本。

### 安装步骤
1.  **下载程序:**
    从 [OpenClaw GitHub Releases](https://github.com/pjasicek/OpenClaw/releases) 下载对应系统的版本。
2.  **准备游戏资源:**
    由于版权原因，引擎不包含原始游戏文件。你需要拥有原版游戏。
    *   找到原版游戏目录下的 `CLAW.REZ` 文件。
    *   将 `CLAW.REZ` 放入 OpenClaw 程序所在的文件夹。
3.  **运行游戏:**
    *   **Windows:** 双击 `OpenClaw.exe`。
    *   **macOS/Linux:** 在终端运行二进制文件或双击 App 包。

---

## 常用命令汇总 (AI 框架)
| 命令 | 描述 |
| :--- | :--- |
| `openclaw onboard` | 首次运行配置 |
| `openclaw gateway start` | 启动网关服务 |
| `openclaw gateway stop` | 停止网关服务 |
| `openclaw dashboard` | 打开仪表盘界面 |
| `openclaw --help` | 查看更多帮助 |
