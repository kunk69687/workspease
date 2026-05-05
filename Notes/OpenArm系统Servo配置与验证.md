---
type: operation
tags: [操作记录, OpenArm, ROS2, MoveIt, Servo]
created: 2026-05-05
updated: 2026-05-05
project: OpenArm
status: active
---

# OpenArm 系统 Servo 配置与验证

## 目的
详细记录 OpenArm 机械臂的 MoveIt Servo 配置参数、构建步骤以及分阶段验证流程。

## 步骤

### 1. 关键配置文件与脚本
已创建以下核心组件：

| 文件 | 位置 | 说明 |
| :--- | :--- | :--- |
| `servo_params_right.yaml` | `openarm_bringup/config/` | 右臂 Servo 参数 |
| `servo_params_left.yaml` | `openarm_bringup/config/` | 左臂 Servo 参数 |
| `openarm_servo.launch.py` | `openarm_bringup/launch/` | Servo 节点启动脚本 |
| `openarm_vr_teleop.py` | `openarm_bringup/scripts/` | VR 遥操作转换脚本 |
| `CMakeLists.txt` | `openarm_bringup/` | 已配置安装上述脚本 |

### 2. 构建流程
```bash
cd ros2_ws
# 仅编译 openarm_bringup 包
colcon build --packages-select openarm_bringup
source install/setup.bash
```

### 3. 系统启动与验证

#### Step A: 启动主系统 (仿真/真机)
```bash
# Fake Hardware 模式
ros2 launch openarm_bimanual_moveit_config demo.launch.py arm_type:=v10 use_fake_hardware:=true
```

#### Step B: 启动 Servo 节点
```bash
ros2 launch openarm_bringup openarm_servo.launch.py
```

#### Step C: 手动验证 Servo 工作状态
在接入 VR 设备前，先通过命令行发布增量指令：
```bash
ros2 topic pub /right_servo_node/delta_twist_cmds \
  geometry_msgs/msg/TwistStamped \
  "{header: {frame_id: 'world'}, twist: {linear: {x: 0.05}}}" --rate 30
```
**判定标准**：若 RViz 中右臂末端匀速向 x 方向移动，则证明 Servo 链路工作正常。

#### Step D: 启动遥操作转换
```bash
ros2 run openarm_bringup openarm_vr_teleop.py
```

## 结果
已确立标准的 Servo 配置与三步验证法，降低了真机联调的风险。

## 备注
- 确保 `frame_id` 与控制器配置文件中的基坐标系一致。
- 构建时务必确认 `install/setup.bash` 已重新 source。

## 相关笔记
- [[OpenArm]]
- [[OpenArm系统启动与调试记录]]
