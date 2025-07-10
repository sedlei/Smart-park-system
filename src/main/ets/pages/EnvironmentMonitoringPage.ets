import { MqttUtil } from "../utils/MqttUtil"


// 温度阈值配置接口
interface TemperatureConfig {
  MIN: number
  MAX: number
  WARNING_LOW: number
  WARNING_HIGH: number
  DEFAULT: number
  STEP: number
}

// 湿度阈值配置接口
interface HumidityConfig {
  MIN: number
  MAX: number
  WARNING_LOW: number
  WARNING_HIGH: number
  DEFAULT: number
  STEP: number
}

const TEMPERATURE: TemperatureConfig = {
  MIN: 0,        // 最低温度
  MAX: 50,       // 最高温度
  WARNING_LOW: 10,  // 低温警告阈值
  WARNING_HIGH: 35, // 高温警告阈值
  DEFAULT: 30,    // 默认阈值
  STEP: 1        // 调节步长
}

const HUMIDITY: HumidityConfig = {
  MIN: 0,        // 最低湿度
  MAX: 100,      // 最高湿度
  WARNING_LOW: 20,  // 低湿度警告阈值
  WARNING_HIGH: 80, // 高湿度警告阈值
  DEFAULT: 70,    // 默认阈值
  STEP: 1        // 调节步长
}

// 状态类型
enum EnvironmentStatusType {
  NORMAL = '正常',
  HIGH = '过高',
  LOW = '过低'
}

// 温度状态判断
function checkTemperatureStatus(value: number): string {
  if (value > TEMPERATURE.WARNING_HIGH) {
    return EnvironmentStatusType.HIGH
  } else if (value < TEMPERATURE.WARNING_LOW) {
    return EnvironmentStatusType.LOW
  }
  return EnvironmentStatusType.NORMAL
}

// 湿度状态判断
function checkHumidityStatus(value: number): string {
  if (value > HUMIDITY.WARNING_HIGH) {
    return EnvironmentStatusType.HIGH
  } else if (value < HUMIDITY.WARNING_LOW) {
    return EnvironmentStatusType.LOW
  }
  return EnvironmentStatusType.NORMAL
}

// 阈值配置接口
interface ThresholdConfig {
  MIN: number
  MAX: number
  STEP: number
}

// 阈值调节函数
function adjustTempThreshold(current: number, increase: boolean): number {
  if (increase) {
    return current < TEMPERATURE.MAX ? current + TEMPERATURE.STEP : current
  }
  return current > TEMPERATURE.MIN ? current - TEMPERATURE.STEP : current
}

function adjustHumidityThreshold(current: number, increase: boolean): number {
  if (increase) {
    return current < HUMIDITY.MAX ? current + HUMIDITY.STEP : current
  }
  return current > HUMIDITY.MIN ? current - HUMIDITY.STEP : current
}

// 标签页数据接口
interface TabData {
  title: string
  icon: Resource
}

// 环境数据接口
interface EnvironmentData {
  temperature: number
  humidity: number
  tempStatus: string
  humidityStatus: string
  tempThreshold: number
  humidityThreshold: number
}

// 安全状态接口
interface SecurityStatus {
  smokeStatus: string
  gasStatus: string
  alarmTesting: boolean
}

// 监控状态接口
interface SystemStatus {
  sensorOnline: boolean
  dataCollectionNormal: boolean
  alarmReady: boolean
  communicationStable: boolean
}
// 光照状态（是否有光）
interface LightMessage {
  hasLight: boolean;   // true = 有光，false = 无光
}

const DEFAULT_LIGHT_DATA: LightMessage = {
  hasLight: true,
};


@ComponentV2
export struct EnvironmentMonitoringPage {
  @Local currentTabIndex: number = 0
  private tabsData: TabData[] = [
    { title: '环境监控', icon: $r('app.media.icon_app') },
    { title: '门禁控制', icon: $r('app.media.icon_app') },
    { title: '安全总览', icon: $r('app.media.icon_app') }
  ]

  @Local environmentData: EnvironmentData = {
    temperature: 21.2,
    humidity: 53.8,
    tempStatus: EnvironmentStatusType.NORMAL,
    humidityStatus: EnvironmentStatusType.NORMAL,
    tempThreshold: TEMPERATURE.DEFAULT,
    humidityThreshold: HUMIDITY.DEFAULT
  }

  @Local securityStatus: SecurityStatus = {
    smokeStatus: '无烟雾',
    gasStatus: '无可燃气体',
    alarmTesting: false
  }

  @Local sensorStatus: SystemStatus = {
    sensorOnline: true,
    dataCollectionNormal: true,
    alarmReady: true,
    communicationStable: true
  }

  private mqttUtil!: MqttUtil;

  async aboutToAppear() {
    // 初始化状态
    this.updateEnvironmentStatus()
    this.mqttUtil = MqttUtil.getInstance()
    await this.mqttUtil.subscribe('home/light', payload => {
      const content = this.mqttUtil.extractContent<LightMessage>(payload);
      this.lightMessage = content;
    });

  }
  @Local lightMessage: LightMessage = DEFAULT_LIGHT_DATA;

  // 更新环境状态
  private updateEnvironmentStatus() {
    this.environmentData.tempStatus = checkTemperatureStatus(this.environmentData.temperature)
    this.environmentData.humidityStatus = checkHumidityStatus(this.environmentData.humidity)
  }

  // 处理温度阈值调节
  private handleTempThresholdChange(increase: boolean) {
    this.environmentData.tempThreshold = adjustTempThreshold(
      this.environmentData.tempThreshold,
      increase
    )
    this.updateEnvironmentStatus()
  }

  // 处理湿度阈值调节
  private handleHumidityThresholdChange(increase: boolean) {
    this.environmentData.humidityThreshold = adjustHumidityThreshold(
      this.environmentData.humidityThreshold,
      increase
    )
    this.updateEnvironmentStatus()
  }

  build() {
    Grid() {
      // 温湿度监控卡片
      GridItem() {
        Column({ space: 10 }) {
          // 标题行
          Row({ space: 5 }) {
            Image($r('app.media.icon_thermometer_blue'))
              .width(15)
              .height(15)
            Text('湿温度检测')
              .width('100%')
              .fontSize(13)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)
          }
          .width('100%')
          .height('15%')
          //.backgroundColor('#317AD3')

          Scroll() {
            Column({ space: 10 }) {
              // 温度监控
              Row({ space: 5 }) {
                // 图标
                Image($r('app.media.icon_thermometer_red'))
                  .width(17)
                  .height(17)
                // 当前温度列
                Column() {
                  Text('当前温度')
                    .fontSize(10)
                    .fontColor('#666666')
                  Row({ space: 10 }) {
                    Row({ space: 4 }) {
                      Text(this.environmentData.temperature.toString())
                        .fontSize(14)
                        .fontWeight(FontWeight.Medium)
                      Text('°C')
                        .fontSize(10)
                    }
                    .width(50)


                    Row() {
                      Text(this.environmentData.tempStatus)
                        .fontSize(10)
                        .fontColor(this.environmentData.tempStatus === '正常' ? '#ffffff' : '#FF5252')
                        .backgroundColor(this.environmentData.tempStatus === '正常' ? '#0f172a' : '#de5329')
                        .height(22)
                        .padding({ left: 8, right: 8 })
                        .borderRadius(11)
                    }
                  }
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)

                // 阈值调整列
                Column({ space: 4 }) {
                  Text('告警阈值')
                    .fontSize(10)
                    .fontColor('#666666')
                  Row({ space: 8 }) {
                    Text('-')
                      .onClick(() => {
                        this.handleTempThresholdChange(false)
                      })
                    Text(this.environmentData.tempThreshold + '°C')
                      .fontSize(14)
                    Text('+')
                      .onClick(() => {
                        this.handleTempThresholdChange(true)
                      })
                  }
                  .width(100)
                  .height(25)
                  .borderRadius(16)
                  .backgroundColor('#F5F5F5')
                  .justifyContent(FlexAlign.SpaceEvenly)
                }
              }
              .width('100%')
              .layoutWeight(1)
              .padding(10)
              .borderRadius(8)
              .borderWidth(1)
              .borderColor('#F8F1F0')
              .backgroundColor('#FFF8F7')

              // 湿度监控
              Row({ space: 5 }) {
                // 图标
                Image($r('app.media.icon_waterdrop'))
                  .width(17)
                  .height(17)
                // 当前湿度列
                Column() {
                  Text('当前湿度')
                    .fontSize(10)
                    .fontColor('#666666')
                  Row({ space: 10 }) {
                    Row({ space: 4 }) {
                      Text(this.environmentData.humidity.toString())
                        .fontSize(14)
                        .fontWeight(FontWeight.Medium)
                      Text('%')
                        .fontSize(10)
                    }
                    .width(50)

                    Row() {
                      Text(this.environmentData.humidityStatus)
                        .fontSize(10)
                        .fontColor(this.environmentData.humidityStatus === '正常' ? '#ffffff' : '#FF5252')
                        .backgroundColor(this.environmentData.humidityStatus === '正常' ? '#0f172a' : '#de5329')
                        .height(22)
                        .padding({ left: 8, right: 8 })
                        .borderRadius(11)
                    }
                  }
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)

                // 阈值调整列
                Column({ space: 4 }) {
                  Text('告警阈值')
                    .fontSize(10)
                    .fontColor('#666666')
                  Row({ space: 8 }) {
                    Text('-')
                      .onClick(() => {
                        this.handleHumidityThresholdChange(false)
                      })
                    Text(this.environmentData.humidityThreshold + '%')
                      .fontSize(14)
                    Text('+')
                      .onClick(() => {
                        this.handleHumidityThresholdChange(true)
                      })
                  }
                  .width(100)
                  .height(25)
                  .backgroundColor('#F5F5F5')
                  .borderRadius(16)
                  .justifyContent(FlexAlign.SpaceEvenly)
                }
              }
              .width('100%')
              .layoutWeight(1)
              .padding(10)
              .borderRadius(8)
              .backgroundColor('#F7FBFF')
            }
            .width('100%')
            .height(150)
          }
          .scrollBar(BarState.Off)
          .height('75%')
        }
        .padding(15)
        .borderRadius(7)
        .backgroundColor('#FFFFFF')
        .shadow({ radius: 6, color: '#1F000000', offsetX: 2, offsetY: 4 })
      }

      // 监控状态卡片组
      GridItem() {
        Column({ space: 10 }) {
          // 标题行
          Row({ space: 5 }) {
            Image($r('app.media.icon_eye_purple'))
              .width(15)
              .height(15)
            Text('监控状态')
              .width('100%')
              .fontSize(13)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)
          }
          .width('100%')
          .height('15%')

          Grid() {
            GridItem() {
              Column({ space: 4 }) {
                Text('传感器')
                  .fontSize(14)
                Text('在线')
                  .fontSize(12)
                  .fontColor('#4CAF50')
              }
              .width('100%')
              .height('100%')
              .padding(8)
              .backgroundColor('#F7FFF7')
              .borderRadius(8)
              .justifyContent(FlexAlign.Center)
              .borderWidth(1)
              .borderColor('#C4F8D6')
            }

            GridItem() {
              Column({ space: 4 }) {
                Text('光照状态')
                  .fontSize(14)
                Text(this.lightMessage.hasLight ? '有光' : '无光')
                  .fontSize(12)
                  .fontColor('#2196F3')
              }
              .width('100%')
              .height('100%')
              .padding(8)
              .backgroundColor('#F7FBFF')
              .borderRadius(8)
              .justifyContent(FlexAlign.Center)
              .borderWidth(1)
              .borderColor('#C7DFFE')
            }

            GridItem() {
              Column({ space: 4 }) {
                Text('报警')
                  .fontSize(14)
                Text('就绪')
                  .fontSize(12)
                  .fontColor('#FFA000')
              }
              .width('100%')
              .height('100%')
              .padding(8)
              .backgroundColor('#FFF8E7')
              .borderRadius(8)
              .justifyContent(FlexAlign.Center)
              .borderWidth(1)
              .borderColor('#FEF29A')
            }

            GridItem() {
              Column({ space: 4 }) {
                Text('通信')
                  .fontSize(14)
                Text('稳定')
                  .fontSize(12)
                  .fontColor('#9C27B0')
              }
              .width('100%')
              .height('100%')
              .padding(8)
              .backgroundColor('#FCF5FF')
              .borderRadius(8)
              .justifyContent(FlexAlign.Center)
              .borderWidth(1)
              .borderColor('#EBDAFF')
            }
          }
          .width('100%')
          .height('75%')
          .columnsGap(10)
          .rowsGap(10)
          .columnsTemplate('1fr 1fr')
          .rowsTemplate('1fr 1fr')
        }
        .padding(15)
        .borderRadius(7)
        .backgroundColor('#FFFFFF')
        .shadow({
          radius: 6,
          color: '#1F000000',
          offsetX: 2,
          offsetY: 4
        })
      }

      // 烟雾和气体检测卡片行
      GridItem() {
        Column({ space: 5 }) {
          // 标题行
          Row({ space: 5 }) {
            Image($r('app.media.icon_smokeSensor'))
              .width(20)
              .height(20)
            Text('烟雾监测')
              .width('100%')
              .fontSize(13)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)
          }
          .width('100%')
          .height('15%')

          // 内容行
          Row({ space: 20 }) {
            // 圆形示意图
            Row(){
              Image($r('app.media.icon_smokeSensor'))
                .flexGrow(1)
            }
            .width(65)
            .height(65)
            .padding(10)
            .borderRadius(32.5)
            .borderWidth(1)
            .borderColor('#D1D5DB')
            .backgroundColor('#F3F4F6')

            // 文本说明和操作区
            Column({ space: 10 }) {
              // 文本说明
              Text(this.securityStatus.smokeStatus)
                .fontSize(14)
                .fontColor(this.securityStatus.smokeStatus === '无烟雾' ? '#ffffff' : '#FF5252')
                .backgroundColor(this.securityStatus.smokeStatus === '无烟雾' ? '#0f172a' : '#de5329')
                .padding({
                  left: 8,
                  right: 8,
                  top: 4,
                  bottom: 4
                })
                .borderRadius(15)
              // 测试告警按钮
              Button('测试警报')
                //.width('100%')
                .height(15)
                .borderRadius(18)
                .fontColor('#A0AEB8')
                //.backgroundColor(this.securityStatus.alarmTesting ? '#FF5252' : '#2196F3')
                .backgroundColor('transparent')
                .onClick(() => {
                  this.securityStatus.alarmTesting = true
                  setTimeout(() => {
                    this.securityStatus.alarmTesting = false
                  }, 3000)
                })
            }
            .width('50%')
            .padding(10)
            //.backgroundColor('#259745')
            .justifyContent(FlexAlign.Center)

          }
          .width('100%')
          .height('75%')
          .justifyContent(FlexAlign.Center)
          //.backgroundColor('#2EC8BA')


        }
        .width('100%')
        .height('100%')
        .backgroundColor('#FFFFFF')
        .borderRadius(7)
        .padding(15)
        .shadow({
          radius: 6,
          color: '#1F000000',
          offsetX: 2,
          offsetY: 4
        })
      }

      // 气体检测卡片
      GridItem() {
        Column({ space: 5 }) {
          // 标题行
          Row({ space: 0 }) {
            Image($r('app.media.icon_flame'))
              .width(20)
              .height(20)
            Text('气体监测')
              .width('100%')
              .fontSize(13)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)
          }
          .width('100%')
          .height('15%')

          // 内容行
          Row({ space: 20 }) {
            // 圆形示意图
            Row() {
              Image($r('app.media.icon_flame'))
                .flexGrow(1)
            }
            .width(65)
            .height(65)
            .padding(10)
            .borderRadius(32.5)
            .borderWidth(1)
            .borderColor('#D1D5DB')
            .backgroundColor('#F3F4F6')

            // 文本说明和操作区
            Column({ space: 10 }) {
              // 文本说明区
              Text(this.securityStatus.gasStatus)
                .fontSize(14)
                .fontColor(this.securityStatus.gasStatus === '无可燃气体' ? '#ffffff' : '#FF5252')
                .backgroundColor(this.securityStatus.gasStatus === '无可燃气体' ? '#0f172a' : '#de5329')
                .padding({
                  left: 8,
                  right: 8,
                  top: 4,
                  bottom: 4
                })
                .borderRadius(15)
              // 按钮操作区
              Button('测试警报')
                .height(15)
                .borderRadius(18)
                .fontColor('#A0AEB8')
                .backgroundColor('transparent')
                //.backgroundColor(this.securityStatus.alarmTesting ? '#FF5252' : '#2196F3')
                .onClick(() => {
                  this.securityStatus.alarmTesting = true
                  setTimeout(() => {
                    this.securityStatus.alarmTesting = false
                  }, 3000)
                })
            }
            .width('50%')
            .height('75%')
            .padding(10)
            //.backgroundColor('#259745')
            .justifyContent(FlexAlign.Center)
          }

        }
        .width('100%')
        .height('100%')
        .padding(15)
        .backgroundColor('#FFFFFF')
        .borderRadius(7)
        //.alignItems(HorizontalAlign.Center)
        .shadow({ radius: 6, color: '#1F000000', offsetX: 2, offsetY: 4 })
      }
    }
    .width('100%')
    .height('100%')
    .padding({ top:5, right:16, bottom:16, left:16 })
    .columnsGap(10)
    .rowsGap(10)
    .columnsTemplate('1fr 1fr')
    .rowsTemplate('5fr 4fr')
    .backgroundColor('#F5F5F5')
  }
}