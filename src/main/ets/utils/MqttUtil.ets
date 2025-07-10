import util from '@ohos.util';
import { MqttAsync, MqttClient, MqttQos, MqttSubscribeOptions, MqttPersistenceType } from '@ohos/mqtt'



interface MqttConfig {
  host: string;
  port: string;
  clientId: string;
  persistenceType: MqttPersistenceType;
  userName: string;
  password: string;
  connectTimeout: number;
  MQTTVersion: number;
  accessKey: string;
}



export class MqttUtil {
  private static instance: MqttUtil
  private constructor() {}
  public static getInstance(): MqttUtil {
    if (!MqttUtil.instance) {
      MqttUtil.instance = new MqttUtil()
    }
    return MqttUtil.instance
  }

  private mqttClient: MqttClient|null=null
  private callbackMap: Map<string, (msg: string) => void> = new Map()
  private mqttConfig!: MqttConfig;
  private isConnected: boolean = false;
  private isListening: boolean = false;



  // 加载配置文件
  private async loadConfigs(): Promise<void> {
    // 读取配置文件数据
    let context = getContext(this);
    const mqttConfigData: Uint8Array = await context.resourceManager.getRawFileContent('MqttConfig.json');
    // 数据转换为文本
    const decoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
    const mqttConfigText = decoder.decodeWithStream(mqttConfigData, { stream: false });
    // 解析为 JS 对象
    const config = JSON.parse(mqttConfigText) as MqttConfig;
    // 制作动态userName
    const timestamp = Date.now().toString();
    const userName = `accessKey=${config.accessKey}|timestamp=${timestamp}|instanceId=4513b637-32f6-4159-a4d5-80ea8d7a6355`;
    this.mqttConfig = {
      host: config.host,
      port: config.port,
      clientId: config.clientId,
      persistenceType: config.persistenceType,
      userName: userName,
      password: config.password,
      connectTimeout: config.connectTimeout,
      MQTTVersion: config.MQTTVersion,
      accessKey: config.accessKey
    };
    console.log('MQTT配置：', mqttConfigText);
  }
  // 创建客户端
  private async createClient(): Promise<void> {
    if (this.mqttConfig === undefined) {
      console.warn('未加载配置文件')
      return;
    }

    const url = `ssl://${this.mqttConfig.host}:${this.mqttConfig.port}`;
    this.mqttClient = MqttAsync.createMqtt({
      url: url,
      clientId: this.mqttConfig.clientId,
      persistenceType: this.mqttConfig.persistenceType
    })
  }
  // 创建连接
  private async createConnect(): Promise<void> {
    if (this.mqttClient === null) {
      console.warn('客户端未创建');
      return;
    }

    await this.mqttClient.connect({
      userName: this.mqttConfig.userName,
      password: this.mqttConfig.password,
      connectTimeout: this.mqttConfig.connectTimeout,
      MQTTVersion: this.mqttConfig.MQTTVersion,
      sslOptions: {
        enableServerCertAuth: false
      }
    }).then(() => {
      this.isConnected = true
      console.info('连接成功')
    }).catch(() => {
      this.isConnected = false
      console.warn('连接失败')
    })
  }
  // 启动消息监听
  private async startListen() {
    if (!this.mqttClient) {
      console.warn('MQTT 客户端未创建');
      return;
    }

    //当收到消息时
    this.mqttClient.messageArrived((err, msg) => {
      const payload = msg.payload as string;
      const topic = JSON.parse(payload).notify_data.body.topic as string
      // 华为云IOT底层策略一条主题全部转发，因此当内外主题不一致时拦截
      if (msg.topic != topic) return;
      console.log('完整消息 JSON：', JSON.stringify(msg));
      console.log('实际主题（topic）：', msg.topic);
      console.log('消息 QoS：', msg.qos);
      const cb = this.callbackMap.get(topic);
      if (cb) cb(payload);
    })
    this.isListening = true;
  }
  // 订阅消息
  public async subscribe(
    topic: string,
    callback: (data: string) => void
  ): Promise<void>{
    if (!this.mqttClient) {
      console.warn('MQTT 客户端未创建');
      return;
    }
    // 启动监听（订阅任意数据，因系统默认转发所有配置过的订阅）
    await this.mqttClient.subscribe({
      topic: topic,
      qos: 0
    }).then((data) => {
      this.callbackMap.set(topic, callback);
      console.info('订阅:', topic, '成功：', JSON.stringify(data))
    }).catch((err: object) => {
      console.error('订阅失败：', JSON.stringify(err))
    })
  }
  // 解析Content
  public extractContent<T>(payload: string): T {
    return JSON.parse(payload).notify_data.body.content as T;
  }


  public async init(){
    // 加载配置文件
    if (!this.mqttConfig) await this.loadConfigs();
    // 创建客户端
    if (!this.mqttClient) await this.createClient();
    // 创建连接
    if (!this.isConnected) await this.createConnect();
    // 开启全局监听
    if (!this.isListening) await this.startListen();
  }
}

