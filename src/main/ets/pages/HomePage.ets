import { MqttUtil } from "../utils/MqttUtil"
import { EnvMessage, EnvironmentData } from '../model/Environment';
import { SystemStatusMessage, SystemStatusData } from '../model/SystemStatus';

// 系统状态
interface SystemStatus {
  name: string
  status: string
  backgroundColor: string
}
// 设备状态
interface DeviceStatus {
  name: string
  status: string
  runtime: string
  current: string
}
// 活体监测
interface PresenceMessage {
  havePeople: boolean;
}
// 默认的环境监控数据
const DEFAULT_ENV_DATA: EnvironmentData[] = [
  { type: '温度', value: 25, unit: '°C', status: '正常' },
  { type: '湿度', value: 60, unit: '%', status: '正常' },
  { type: '空气质量', value: 0, unit: '', status: '优' },
];
// 默认的系统状态数据
const DEFAULT_SYSSTATUS_DATA: SystemStatus[] = [
  { name: '温度系统', status: '正常', backgroundColor: '#E8F5E9' },
  { name: '设备系统', status: '正常', backgroundColor: '#E8F5E9' },
  { name: '安全系统', status: '正常', backgroundColor: '#E8F5E9' },
]
// 默认的活体监测数据
const DEFAULT_PRESENCE_DATA: PresenceMessage = {
  havePeople: false,
}

@Component
export struct HomePage {
  private mqttUtil!: MqttUtil;
  async aboutToAppear() {
    this.mqttUtil = MqttUtil.getInstance()
    await this.mqttUtil.init();
    await this.mqttUtil.subscribe('home/env',(payload) => {
      const content = this.mqttUtil.extractContent<EnvMessage>(payload)
      this.environmentData = content.envData
    })
    await this.mqttUtil.subscribe('home/people',(payload) => {
      const content = this.mqttUtil.extractContent<PresenceMessage>(payload);
      this.presenceMessage = content;
    })
    await this.mqttUtil.subscribe('home/status',(payload) => {
      const content = this.mqttUtil.extractContent<SystemStatusMessage>(payload)
      this.systemStatusList = content.systemStatus
    })
  }
  @State environmentData: EnvironmentData[] = DEFAULT_ENV_DATA;
  @State systemStatusList: SystemStatus[] = DEFAULT_SYSSTATUS_DATA;
  @State presenceMessage: PresenceMessage = DEFAULT_PRESENCE_DATA;


  // 设备运行状态数据
  @State deviceStatusList: DeviceStatus[] = [
    { name: '设备A', status: '运行中', runtime: '8.5h', current: '15.2A' },
    { name: '设备B', status: '断电', runtime: '0h', current: '0A' },
    { name: '设备C', status: '断电', runtime: '0h', current: '0A' },
    { name: '设备D', status: '断电', runtime: '0h', current: '0A' },
  ]

  // 环境监控卡片构建器
  @Builder EnvironmentCard() {
    Column() {
      // 卡片标题
      Row({ space: 5 }) {
        Image($r("app.media.icon_thermometer"))
          .width(20)
          .height(20)
        Text("环境监控")
          .width(150)
          .fontSize(13)
          .fontWeight('bold')
      }
      .width('100%')
      .height('25%')
      //.backgroundColor('#6754FF')

      // 卡片内容
      Row() {
        ForEach(this.environmentData, (item: EnvironmentData) => {
          Column({ space: 5 }) {
            Text(item.type == '空气质量'
              ? item.status
              : item.value.toString() + item.unit)
              .fontWeight('bold')
              .fontColor(item.type == '空气质量' ? '#2BA753' : '#000000')
              .fontSize(18)
            Text(item.type)
              .fontColor('#707E94')
              .fontSize(13)
          }
          .height('70%')
          //.backgroundColor('#269745')
        })
      }
      .width('100%')
      .height('75')
      .justifyContent(FlexAlign.SpaceEvenly)
      //.backgroundColor('#FFA04A')
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#ffffff')
    .borderRadius(8)
    .padding(20)
    .shadow({ radius: 6, color: '#1F000000', offsetX: 2, offsetY: 4 })
  }
  // 系统状态卡片构建起
  @Builder SysStatusCard() {
    Column() {
      // 卡片标题
      Row({ space: 5 }) {
        Image($r("app.media.icon_heartbeat"))
          .width(20)
          .height(20)
        Text("系统状态")
          .width(150)
          .fontSize(13)
          .fontWeight('bold')
      }
      .width('100%')
      .height('25%')
      //.backgroundColor('#6754FF')

      // 卡片内容
      Row() {
        ForEach(this.systemStatusList, (item: SystemStatus) => {
          Column({ space: 5 }) {
            Text(item.status)
              .fontWeight('bold')
              .fontColor('#2BA753')
              .fontSize(14)
            Text(item.name)
              .fontColor('#707E94')
              .fontSize(13)
          }
          .width('30%')
          .height('90%')
          .borderRadius(8)
          .justifyContent(FlexAlign.SpaceEvenly)
          .backgroundColor('#F0FDF4')
        })
      }
      .width('100%')
      .height('60')
      .justifyContent(FlexAlign.SpaceEvenly)
      //.backgroundColor('#FFA04A')
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#ffffff')
    .borderRadius(8)
    .padding(20)
    .shadow({ radius: 6, color: '#1F000000', offsetX: 2, offsetY: 4 })
  }
  // 设备状态卡片构建器
  @Builder DeviceStatusCard() {
    Column({ space: 5 }) {
      // 卡片标题
      Row({ space: 5 }) {
        Image($r("app.media.icon_energy"))
          .width(20)
          .height(20)
        Text("设备运行状态")
          .width(150)
          .fontSize(13)
          .fontWeight('bold')
      }
      .width('100%')
      .height('15%')
      //.backgroundColor('#6754FF')

      // 设备项
      Scroll() {
        Column() {
          ForEach(this.deviceStatusList, (item: DeviceStatus) => {
            Row() {
              Column({ space: 2 }){
                Text(item.name)
                  .fontSize(14)
                Text(item.status)
                  .fontSize(13)
                  .fontColor('#707E94')
              }
              Column({ space: 2 }){
                Text(item.runtime)
                  .fontSize(14)
                Text(item.current)
                  .fontSize(13)
                  .fontColor('#707E94')
              }
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')
            .padding(12)
            .backgroundColor('#F5F5F5')
            .borderRadius(4)
            .margin({ bottom: 8 })
          })
        }
      }
      .width('100%')
      .height('78%')
      .scrollBar(BarState.Off)
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#ffffff')
    .borderRadius(8)
    .padding(20)
    .shadow({ radius: 6, color: '#1F000000', offsetX: 2, offsetY: 4 })
  }
  // 安全监控卡片构建器
  @Builder SafeMonitoringCard() {
    Column({ space: 5 }) {
      // 卡片标题
      Row({ space: 5 }) {
        Image($r("app.media.icon_monitoring"))
          .width(20)
          .height(20)
        Text("安全监控")
          .width(150)
          .fontSize(13)
          .fontWeight('bold')
      }
      .width('100%')
      .height('15%')
      // 卡片内容
      Grid() {
        //烟雾监测
        GridItem(){
          Column() {
            Text('烟雾监测')
              //.width(50)
              .fontSize(14)
              .fontColor('#176B3E')
            Text('正常')
              //.width(50)
              .fontSize(13)
              .fontColor('#86C1B5')
          }
          .width('100%')
          .height('100%')
          .borderWidth(1)
          .borderColor('#C9F8D9')
          .borderRadius(8)
          .padding(15)
          .alignItems(HorizontalAlign.Start)
        }
        .backgroundColor('#F0FDF4')
        //气体监测
        GridItem(){
          Column() {
            Text('气体监测')
            //.width(50)
              .fontSize(14)
              .fontColor('#176B3E')
            Text('正常')
            //.width(50)
              .fontSize(13)
              .fontColor('#86C1B5')
          }
          .width('100%')
          .height('100%')
          .borderWidth(1)
          .borderColor('#C9F8D9')
          .borderRadius(8)
          .padding(15)
          .alignItems(HorizontalAlign.Start)
        }
        .backgroundColor('#F0FDF4')
        //大门状态
        GridItem(){
          Column() {
            Text('大门状态')
            //.width(50)
              .fontSize(14)
              .fontColor('#1E42AF')
            Text('已关闭')
            //.width(50)
              .fontSize(13)
              .fontColor('#1E42AF')
          }
          .width('100%')
          .height('100%')
          .borderWidth(1)
          .borderColor('#D9EAFE')
          .borderRadius(8)
          .padding(15)
          .alignItems(HorizontalAlign.Start)
        }
        .backgroundColor('#EFF6FF')
        //活体监测
        GridItem(){
          Column() {
            Text('活体监测')
            //.width(50)
              .fontSize(14)
              .fontColor('#374955')
            Text(this.presenceMessage.havePeople == true ? "有人员" : "无人员")
            //.width(50)
              .fontSize(13)
              .fontColor('#374955')
          }
          .width('100%')
          .height('100%')
          .borderWidth(1)
          .borderColor('#F0F1F3')
          .borderRadius(8)
          .padding(15)
          .alignItems(HorizontalAlign.Start)
        }
        .backgroundColor('#F9FAFB')
      }
      .width('100%')
      .height('70%')
      .rowsTemplate('1fr 1fr')
      .columnsTemplate('1fr 1fr')
      .rowsGap(10)
      .columnsGap(10)
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#ffffff')
    .borderRadius(8)
    .padding(20)
    .shadow({ radius: 6, color: '#1F000000', offsetX: 2, offsetY: 4 })
  }

  build() {
    Row() {
      // 主内容区域
      Column() {
        Grid() {
          // 环境监控模块
          GridItem() { this.EnvironmentCard() }
          // 系统状态模块
          GridItem() { this.SysStatusCard() }
          // 设备运行状态模块
          GridItem() { this.DeviceStatusCard() }
          // 安全监控模块
          GridItem() { this.SafeMonitoringCard() }
        }
        .width('100%')
        .height('100%')
        .columnsTemplate('1fr 1fr')
        .rowsTemplate('35% 1fr')
        .columnsGap(15)
        .rowsGap(15)
        .padding(15)
      }
      .layoutWeight(1)
      .height('100%')
      .backgroundColor('#F5F5F5')

      // // 测试
      // Row() {
      //   Button("测试测试")
      //     .backgroundColor('#123456')
      //     .onClick(async () => {
      //       await this.mqttUtil.subscribe<EnvMessage>('hello', (msg: EnvMessage) => {
      //         const list: EnvironmentData[] = msg.envData;
      //         this.environmentData  = list;
      //       });
      //     })
      // }

    }
    .width('100%')
    .height('100%')
  }
}
