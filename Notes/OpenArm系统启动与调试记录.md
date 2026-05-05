---
type: operation
tags: [操作记录, OpenArm, ROS2, CAN]
created: 2026-05-05
updated: 2026-05-05
project: OpenArm
status: active
---

# OpenArm 系统启动与调试记录

## 目的
记录 OpenArm 机械臂的 CAN 总线配置、系统启动、关节测试以及零位校准的标准操作流程。

## 步骤

### 1. CAN 总线配置
确认适配器状态并配置 SocketCAN。
```bash
# 检查设备识别情况
ip link show can0

# 配置 SocketCAN (FD 模式, 波特率 1M/5M)
openarm-can-configure-socketcan can0 -fd -b 1000000 -d 5000000
openarm-can-configure-socketcan can1 -fd -b 1000000 -d 5000000
```

### 2. 环境初始化
```bash
source ~/openarm/install/setup.bash
```

### 3. 系统启动
```bash
# 仿真模式启动 (Fake Hardware)
ros2 launch openarm_bimanual_moveit_config demo.launch.py arm_type:=v10 use_fake_hardware:=true

# 实体模式启动 (带电机)
ros2 launch openarm_bimanual_moveit_config demo.launch.py arm_type:=v10
```

### 4. 关节运动测试 (Action)
通过发送 Action 目标验证左右臂关节是否工作正常。

**左臂测试：**
```bash
ros2 action send_goal /left_joint_trajectory_controller/follow_joint_trajectory \
control_msgs/action/FollowJointTrajectory \
'{trajectory: {joint_names: ["openarm_left_joint1", "openarm_left_joint2", "openarm_left_joint3", "openarm_left_joint4", "openarm_left_joint5", "openarm_left_joint6", "openarm_left_joint7"], points: [{positions: [0.15, 0.15, 0.15, 0.15, 0.15, 0.15, 0.15], time_from_start: {sec: 3, nanosec: 0}}]}}'
```

**右臂测试：**
```bash
ros2 action send_goal /right_joint_trajectory_controller/follow_joint_trajectory \
control_msgs/action/FollowJointTrajectory \
'{trajectory: {joint_names: ["openarm_right_joint1", "openarm_right_joint2", "openarm_right_joint3", "openarm_right_joint4", "openarm_right_joint5", "openarm_right_joint6", "openarm_right_joint7"], points: [{positions: [0.15, 0.15, 0.15, 0.15, 0.15, 0.15, 0.15], time_from_start: {sec: 3, nanosec: 0}}]}}'
```

### 5. 数据流与控制器状态监控
```bash
# 查看话题列表
ros2 topic list

# 查看当前运行的控制器及其管理的关节
ros2 control list_controllers

# 观察控制误差 (判断堵转或力矩不足)
ros2 topic echo /joint_trajectory_controller/state
```

### 6. 零位校准
注意：零位校准一次只能操作一个手臂。

**常用校准命令：**
```bash
# 右臂 (默认 can0)
openarm-can-zero-position-calibration --canport can0 --arm-side right_arm

# 左臂 (默认 can1)
openarm-can-zero-position-calibration --canport can1 --arm-side left_arm
```

**多臂/多端口特定校准：**
```bash
# 主控左臂
openarm-can-zero-position-calibration --canport can1 --arm_side left_arm
# 从控右臂
openarm-can-zero-position-calibration --canport can2 --arm_side right_arm
# 从控左臂
openarm-can-zero-position-calibration --canport can3 --arm_side left_arm
```

## 结果
成功整理了 OpenArm 的核心调试指令，可作为后续真机调试的快速参考手册。

## 备注
- 在 `fake_hardware` 模式下，`error` 字段几乎为 0。
- 真机调试时需密切关注 `/joint_trajectory_controller/state` 中的误差数值。

## 相关笔记
- [[OpenArm]]
- [[工作1]]

## 来源
用户提供的原始调试笔记。
