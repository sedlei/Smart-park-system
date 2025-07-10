import {
  IoTDevice, DeviceMessage, IoTMqttResponse, RawMessage, RawDeviceMessage,RawDeviceMessageListener
} from '@huaweicloud/iot-device-sdk';
import util from '@ohos.util';


interface IotConfig { host: string; port: number }
interface DeviceEntry { key: string; deviceId: string; secret: string }

export class IotUtil {
  private constructor() {}
  private static instance: IotUtil;
  public static getInstance() {
    if (!IotUtil.instance) {
      IotUtil.instance = new IotUtil();
    }
    return IotUtil.instance;
  }
  // 私有成员
  private device: IoTDevice | null = null;
  private clients: Record<string, IoTDevice> = {};
  private url!: string;
  private IotConfig!: IotConfig;
  private deviceConfig!: DeviceEntry[];
  private isConnecting: boolean = false;
  private connectingSuccess = false;

  // 加载配置文件
  private async loadConfigs(): Promise<void> {
    // 读取配置文件数据
    let context = getContext(this);
    const iotConfigData: Uint8Array = await context.resourceManager.getRawFileContent('IotConfig.json');
    const deviceConfigData: Uint8Array = await context.resourceManager.getRawFileContent('DeviceConfig.json');
    // 数据转换为文本
    const decoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
    const iotConfigText = decoder.decodeWithStream(iotConfigData, { stream: false });
    const deviceConfigText = decoder.decodeWithStream(deviceConfigData, { stream: false });
    console.log('Iot配置：', iotConfigText);
    console.log('DEVICE配置：', deviceConfigText);
    // 解析为 JS 对象
    this.IotConfig = JSON.parse(iotConfigText) as IotConfig;
    this.deviceConfig = JSON.parse(deviceConfigText).devices as DeviceEntry[];
  }
  // 初始化连接
  public async initAll(): Promise<void> {
    await this.loadConfigs();
    this.url = `ssl://${this.IotConfig.host}:${this.IotConfig.port}`;
    for (const cfg of this.deviceConfig) {
      const client = new IoTDevice(this.url, cfg.deviceId, cfg.secret, 'GlobalSign-rootca.pem');
      console.log('正在连接：' + cfg.key);
      try {
        if (await client.init()) this.clients[cfg.key] = client;
      } catch (err) {
        console.error(cfg.key + " 连接失败", err.message);
        this.isConnecting = false
        this.connectingSuccess = true
        return;
      }
      console.log(cfg.key + '连接成功')
      this.isConnecting = false
    }
  }


  /** —— 上报消息 —— */
  /*  参数1：设备KEY
   *  参数2：消息内容
   *  参数3：自定义topic
   *  参数4：qos等级
   *  默认topic： $oc/devices/{device_id}/sys/messages/up
   */
  public async report(
    deviceKey: string,
    data: string,
    topic?: string,
    qos?: number): Promise<void> {
    // 设备连接检查
    let device = this.clients[deviceKey]
    if (!device) {
      throw new Error('设备未初始化');
    }

    // 系统消息
    if (topic === undefined && qos === undefined) {
      const reportMessage: DeviceMessage = { content: data };
      try {
        const res: IoTMqttResponse = await device.client.reportDeviceMessage(reportMessage);
        console.log("上报系统消息成功：" + JSON.stringify(res));
      } catch (err) {
        console.error("上报系统消息失败：", err);
      }
    }

    // 自定义消息
    else
    {
      device.client.publishRawMessage({
        topic: topic,
        qos: qos!,
        payload: JSON.stringify(data),
      }).then((res: IoTMqttResponse) => {
        console.log(`上报自定义消息，data=${data}, topic=${topic}, qos=${qos},res=${res}`);
      }).catch((err: IoTMqttResponse | string) => {
        console.error(`上报自定义消息失败：${JSON.stringify(err)}`);
      });
    }
  }

  /** —— 监听消息 —— */
  /*  参数1：设备KEY
   *  参数2：回调函数以接收数据
   *  参数3：自定义topic
   *  默认topic: $oc/devices/{device_id}/sys/messages/down
   */
  public async listen<T>(
    deviceKey: string,
    handler: (data: T) => void,
    topic?: string
  ): Promise<void> {
    // 设备连接检查
    let device = this.clients[deviceKey]
    if (!device) {
      throw new Error('设备未初始化');
    }

    // 监听系统消息
    if (topic === undefined) {
      console.log('开始监听系统消息')
      device.client.rawDeviceMessageListener = {
        onRawDeviceMessage: (msg: RawDeviceMessage) => {
          const obj = JSON.stringify(msg) as T;
          handler(obj);
        }
      }
    }
    // 监听自定义消息
    else {
      console.log('开始订阅:',topic,'消息')
      try {
        await device.client.subscribeTopic(topic, {
          onMessageReceived: (msg: RawMessage) => {
            const obj = JSON.stringify(msg) as T;
            handler(obj);
          }
        })
      } catch (e) {
        console.error('订阅失败：', e.message());
        return;
      }
    }
  }
}