// Environment  环境监控数据模型

// MQTT 消息载体
export interface EnvMessage {
  deviceId: string;
  envData: EnvironmentData[];
}

// 单条测点
export interface EnvironmentData {
  type: string;
  value: number;
  unit: string;
  status: string;
}

