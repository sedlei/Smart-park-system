// SystemStatus 系统状态模型

// 系统状态消息载体
export interface SystemStatusMessage {
  deviceId: string;
  systemStatus: SystemStatusData[];
}

// 单条系统状态
export interface SystemStatusData {
  name: string;
  status: string;
  backgroundColor: string;
}

