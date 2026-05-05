---
type: project
tags: [项目, 机器人, 遥操作]
created: 2026-05-05
updated: 2026-05-05
status: active
---

# OpenArm 遥操作项目

## 目标
实现基于 ROS 2 和 VR 设备的双臂机械臂（Franka）遥操作控制系统，支持笛卡尔阻抗控制和增量式映射。

## 当前状态
- 已完成控制器架构解析。
- 已配置 Servo 节点参数。
- 待进行物理验证。

## 笔记索引
- [[OpenArm项目架构解析-franka_controllers_real]]：深入解析了基于 ROS 2 的实时控制器实现、1000Hz 数据流及增量式 VR 映射逻辑。
- [[OpenArm系统Servo配置与验证]]：记录了 MoveIt Servo 节点的详细配置、构建步骤及分阶段验证流程。
- [[OpenArm系统启动与调试记录]]：汇总了 CAN 配置、SocketCAN 设置、系统启动、关节测试及零位校准的标准操作指令。

## 待办
- [ ] 执行 [[OpenArm系统Servo配置与验证]] 中的 Step 1 - Step 3：构建并启动主系统与 Servo 节点。
- [ ] 执行 Step 4：手动验证 Servo 话题控制。
- [ ] 执行 Step 5：接入 VR 设备进行真机遥操作测试。

## 项目日志
- [[项目日志]]
