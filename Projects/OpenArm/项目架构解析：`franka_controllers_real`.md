

这是一个基于 **ROS 2** 的 **Franka 机械臂实时控制系统**，核心是阻抗控制器 + VR 遥操作，专为真实机器人（非仿真）设计。

---

### 📁 文件树总览

franka_controllers_real/

├── CMakeLists.txt              # ROS 2 编译配置

├── package.xml                 # 包依赖声明

├── serl_controllers_plugin.xml # 控制器插件注册

│

├── include/serl_franka_controllers/

│   ├── cartesian_impedance_controller_real.hpp  # 控制器类声明

│   └── pseudo_inversion.h                        # 矩阵伪逆工具

│

├── src/

│   └── cartesian_impedance_controller_real.cpp  # ⭐ 核心控制器实现 (C++)

│

├── scripts/

│   ├── dual_arm_vr_teleop.py    # ⭐ 双臂VR遥操作 (Python)

│   ├── gripper_wrapper.py       # 夹爪控制封装

│   └── set_collision_thresholds.py  # 碰撞阈值设置

│

├── config/

│   └── cartesian_impedance_controller_real.yaml  # 控制器参数配置

│

├── launch/

│   ├── cartesian_impedance_controller.launch.py  # 主启动文件

│   └── rt_server.launch.py                        # 实时服务器启动

│

└── msg/

    ├── SimplifiedFrankaState.msg  # 自定义机器人状态消息

    └── ZeroJacobian.msg           # 雅可比矩阵消息

---

### 🔄 系统整体数据流

mermaid

graph TD

    A["🥽 VR 控制器<br/>(Quest / SteamVR)"] -->|UDP JSON @ 5555端口| B["dual_arm_vr_teleop.py<br/>(Python ROS2节点)"]

    B -->|geometry_msgs/PoseStamped<br/>/NS_1/.../equilibrium_pose| C["CartesianImpedanceControllerReal<br/>(C++ ROS2控制器, 1000Hz)"]

    B -->|geometry_msgs/PoseStamped<br/>/NS_2/.../equilibrium_pose| D["CartesianImpedanceControllerReal<br/>(左臂控制器)"]

    C -->|读取| E["Franka Robot State<br/>(关节位置/速度/Jacobian)"]

    C -->|发送| F["关节力矩命令<br/>(7个关节 @ 1kHz)"]

    C -->|发布| G["~/current_pose<br/>~/jacobian<br/>~/error"]

    G -->|反馈| B

    B -->|Action Goal| H["Franka Gripper<br/>(grasp/move/homing)"]

    I["gripper_wrapper.py"] -->|Action Goal| H

---

### ⭐ 核心模块详解

#### 1. 笛卡尔阻抗控制器（C++，1000Hz 实时）

**文件**: `src/cartesian_impedance_controller_real.cpp`

这是整个系统的**控制核心**，以 1000Hz 运行在实时线程中。每个控制周期执行以下步骤：

每个控制周期 (1ms):

每个控制周期 (1ms):
┌─────────────────────────────────────────────┐
│ 1. 读取状态                                  │
│    - 关节位置 q, 速度 dq (7维)              │
│    - 末端位姿 (通过 Franka Robot Model)      │
│    - Jacobian 矩阵 J (6x7)                   │
│    - Coriolis 力                             │
├─────────────────────────────────────────────┤
│ 2. 更新目标 (带低通滤波)                     │
│    position_d_ = α·p_target + (1-α)·p_d     │
│    (α = filter_params = 0.005)              │
├─────────────────────────────────────────────┤
│ 3. 计算位置/姿态误差                         │
│    error = [pos_error (clip±0.1m),          │
│             rot_error (clip±0.1rad)]        │
├─────────────────────────────────────────────┤
│ 4. 计算控制力矩                              │
│    τ_task = Jᵀ(-K·e - D·J·dq - Ki·∫e)     │
│    τ_null = (I - Jᵀ·J†)(Kn·q_err)         │
│    τ = τ_task + τ_null + Coriolis          │
├─────────────────────────────────────────────┤
│ 5. 力矩限幅 (Δτ ≤ 1.0 Nm/周期)             │
│    → 发送到7个关节                          │
└─────────────────────────────────────────────┘

**关键参数**（`config/yaml` 中可调）：

|参数|默认值|含义|
|---|---|---|
|`translational_stiffness`|2000 N/m|平移方向弹簧刚度|
|`rotational_stiffness`|150 Nm/rad|旋转方向弹簧刚度|
|`translational_damping`|75 Ns/m|平移阻尼（理论临界阻尼≈89）|
|`nullspace_stiffness`|0.2|零空间刚度（避免奇异构型）|
|`filter_params`|0.005|目标位姿低通滤波系数|
|`translational_clip`|±0.10 m|误差截断（安全保护）|

---

#### 2. VR 遥操作 (Python)

**文件**: `scripts/dual_arm_vr_teleop.py`

採用**增量式映射**算法，核心逻辑：

握住Grip键的那一刻：快照 VR 控制器位置 (vr_ref) + 机械臂当前位置 (robot_ref)

持续握住时：

  delta_pos = (vr_now - vr_ref) × position_scale  # 位移增量

  target_pos = robot_ref + delta_pos               # 叠加到机械臂参考位置

  d_rot = R(vr_now) × R(vr_ref)⁻¹                # 旋转增量

  target_quat = d_rot × robot_ref_quat            # 叠加到机械臂参考姿态

松开Grip键：冻结机械臂当前位置（不会回弹）

**按键映射**：

| VR 按键             | 动作                         |
| ----------------- | -------------------------- |
| `Grip`（右手）        | 右臂开始跟随运动                   |
| `Grip`（左手）        | 左臂开始跟随运动                   |
| `Trigger`（任意手）    | 开/关夹爪                      |
| 双手松开Grip + 右手按`B` | 触发双臂同步回零                   |
| 右手按`A`            | 发布 `/button_A` 消息（供外部逻辑使用） |

**回零算法**（`execute_dual_homing`）：使用 **Smooth Step** 插值（5秒），位置线性插值 + 姿态 SLERP，握住任意 Grip 可中断。

---

#### 3. 夹爪封装 (`gripper_wrapper.py`)

对 `franka_gripper` Action 接口做了简单封装，订阅两种话题：

- `/{ns}/gripper_cmd_string` → `"open"` / `"close"` / `"homing"`
- `/{ns}/gripper_cmd_width` → 任意宽度（float，单位 m）

---

### 🚀 启动流程

ros2 launch serl_franka_controllers cartesian_impedance_controller.launch.py

launch 文件会读取 `franka.config.yaml`（`franka_bringup` 包），对每个机械臂依次启动：

1. `franka.launch.py` → 机器人驱动层（连接真实机器臂）
2. `spawner` → 激活 `cartesian_impedance_controller`
3. `gripper_wrapper.py` → 夹爪话题封装

然后单独启动遥操作脚本：

ros2 run serl_franka_controllers dual_arm_vr_teleop.py

---

### 🔑 设计要点总结

|特性|实现方式|
|---|---|
|**安全性**|误差截断（clip）+ 力矩变化速率限制|
|**柔顺性**|阻抗控制（弹簧-阻尼模型）不是位置/速度控制|
|**构型稳定**|零空间（nullspace）分量维持关节不超限|
|**参数平滑**|低通滤波（filter_params=0.005）防止目标跳变|
|**遥操作直觉**|增量映射 = 只跟踪"相对位移"，避免工作空间不匹配问题|
|**双臂协调**|两套独立 `SingleArmController`，用命名空间 `/NS_1` `/NS_2` 隔离|