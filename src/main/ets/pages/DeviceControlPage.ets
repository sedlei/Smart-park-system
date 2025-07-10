
let INITIAL_DEVICES: Array<DeviceInfo> = [
  { name: '生产线A', voltage: 220, current: 12.2, duration: 0, status: true, isRunning: false },
  { name: '生产线B', voltage: 457, current: 28.2, duration: 37.8, status: true, isRunning: false },
  { name: '包装线A', voltage: 219, current: 14.9, duration: 31.8, status: true, isRunning: false },
  { name: '包装线B', voltage: 0, current: 0, duration: 0, status: false, isRunning: false },
  { name: '检测线A', voltage: 380, current: 15.6, duration: 24.5, status: true, isRunning: false },
  { name: '检测线B', voltage: 380, current: 16.2, duration: 22.1, status: true, isRunning: false }
]

let INITIAL_SYSTEM_INFO: SystemStatus = {
  runningDevices: 4,
  stoppedDevices: 2,
  faultDevices: 2,
  totalHours: 153,
  systemLoad: '17.9kW',
  runningStatus: '67%',
  faultRate: '33%',
  todayStartCount: 24,
  averageLoad: '78%',
  power: '156.8kWh'
}

interface DeviceInfo {
  name: string
  voltage: number
  current: number
  duration: number
  status: boolean
  isRunning: boolean
}

interface SystemStatus {
  runningDevices: number
  stoppedDevices: number
  faultDevices: number
  totalHours: number
  systemLoad: string
  runningStatus: string
  faultRate: string
  todayStartCount: number
  averageLoad: string
  power: string
}

@ComponentV2
export struct DeviceControlPage {
  @Local devices: Array<DeviceInfo> = INITIAL_DEVICES
  @Local systemInfo: SystemStatus = INITIAL_SYSTEM_INFO
  private lastStartCount: number = 0

  // 更新系统信息方法
  updateSystemInfo() {
    let running = 0;
    let stopped = 0;

    // 统计运行和停止的设备数量
    this.devices.forEach(device => {
      if (device.status) {
        running++;
      } else {
        stopped++;
      }
    });

    // 创建新的系统信息对象
    const updatedSystemInfo: SystemStatus = {
      runningDevices: running,
      stoppedDevices: stopped,
      faultDevices: this.systemInfo.faultDevices,
      totalHours: this.systemInfo.totalHours,
      systemLoad: this.systemInfo.systemLoad,
      runningStatus: Math.round((running / this.devices.length) * 100) + '%',
      faultRate: this.systemInfo.faultRate,
      todayStartCount: (this.lastStartCount || this.systemInfo.todayStartCount) + 1,
      averageLoad: this.systemInfo.averageLoad,
      power: this.systemInfo.power
    };

    // 更新状态
    this.systemInfo = updatedSystemInfo;
    this.lastStartCount = updatedSystemInfo.todayStartCount;
  }

  build() {
    Row() {

      // 设备列
      Column() {
          Grid() {
            ForEach(this.devices, (device: DeviceInfo) => {
              GridItem() {
                this.DeviceCard(device)
              }
            })
          }
          .scrollBar(BarState.Off)
          .columnsTemplate('1fr 1fr')
          .rowsGap(12)
          .columnsGap(12)
          .width('100%')
          .height('100%')
      }
      .width('70%')
      .height('100%')
      .padding(12)

      // 总览列
      Column() {
        this.SystemInfoPanel()
      }
      .width('30%')
      .height('100%')
      .padding(12)
      .backgroundColor(Color.White)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f3f4f6')
  }

  @Builder
  DeviceCard(device: DeviceInfo) {
    Column() {
      // 设备名称和状态
      Row() {
        Text(device.name)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
        if (device.status) {
          Text('运行中')
            .fontSize(12)
            .fontColor(Color.Green)
        } else {
          Text('停止')
            .fontSize(12)
            .fontColor(Color.Gray)
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ bottom: 10 })

      // 设备参数
      Row() {
        Column() {
          Text(device.voltage.toString() + 'V')
            .fontSize(14)
          Text('电压')
            .fontSize(10)
            .fontColor(Color.Gray)
        }
        .layoutWeight(1)

        Column() {
          Text(device.current.toString() + 'A')
            .fontSize(14)
          Text('电流')
            .fontSize(10)
            .fontColor(Color.Gray)
        }
        .layoutWeight(1)

        Column() {
          Text(device.duration.toString() + 'h')
            .fontSize(14)
          Text('时长')
            .fontSize(10)
            .fontColor(Color.Gray)
        }
        .layoutWeight(1)
      }
      .width('100%')
      .padding({ bottom: 8 })

      // 设备状态
      Text(device.status ? '设备运行正常' : '设备已停止')
        .fontSize(12)
        .fontColor(device.status ? Color.Green : Color.Gray)
        .padding({ bottom: 8 })

      // 设备控制
      Button(device.isRunning ? '关闭' : '启动')
        .width('100%')
        .height(32)
        .fontSize(12)
        .backgroundColor(device.isRunning ? '#EF4444' : '#0F172A')
        .onClick(() => {
          // 创建设备数组的新副本
          let updatedDevices: Array<DeviceInfo> = [...this.devices];
          // 找到当前设备的索引
          let index = updatedDevices.findIndex(d => d.name === device.name);
          if (index !== -1) {
            // 更新设备状态
            let updatedDevice: DeviceInfo = {
              name: device.name,
              voltage: device.voltage,
              current: device.current,
              duration: device.duration,
              isRunning: !device.isRunning,
              status: !device.isRunning
            };
            updatedDevices[index] = updatedDevice;
            // 更新整个数组以触发状态更新
            this.devices = updatedDevices;
            // 更新系统信息
            this.updateSystemInfo();
          }
        })
    }
    .width('100%')
    .padding(12)
    .borderRadius(8)
    .backgroundColor(Color.White)
    .shadow({ radius: 6, color: '#1F000000', offsetX: 2, offsetY: 4 })
  }

  @Builder
  SystemInfoPanel() {
    Column({ space: 7 }) {
      // 标题行
      Row() {
        Text('设备运行总览')
          .fontSize(14)
          .width('100%')
          .textAlign(TextAlign.Start)
      }
      .width('100%')

      // 方块概览区
      Column({ space: 10 }) {
        Row({ space: 10 }) {
          Column() {
            Text(this.systemInfo.runningDevices.toString())
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
            Text('运行中')
              .fontSize(14)
              .fontColor(Color.Green)
          }
          .padding(10)
          .layoutWeight(1)
          .backgroundColor('#f0fdf4')

          Column() {
            Text(this.systemInfo.stoppedDevices.toString())
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
            Text('已停止')
              .fontSize(14)
              .fontColor(Color.Gray)
          }
          .padding(10)
          .layoutWeight(1)
          .backgroundColor('#f9fafb')
        }
        .width('100%')
        //.backgroundColor('#45D987')

        Row({ space: 10 }) {
          Column() {
            Text(this.systemInfo.faultDevices.toString())
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.Red)
            Text('故障设备')
              .fontSize(14)
              .fontColor(Color.Gray)
          }
          .padding(10)
          .layoutWeight(1)
          .backgroundColor('#fef2f2')

          Column() {
            Text(this.systemInfo.totalHours.toString())
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
            Text('总时长(h)')
              .fontSize(14)
              .fontColor(Color.Gray)
          }
          .padding(10)
          .layoutWeight(1)
          .backgroundColor('#eff6ff')
        }
        .width('100%')
        //.backgroundColor('#45D987')
      }
      .width('100%')
      .padding({ bottom: 5 })

      // 系统状态区
      Column({ space: 5 }) {
        Text('系统状态')
          .fontSize(13)
          .width('100%')
          .textAlign(TextAlign.Start)
          .margin({bottom:5})
        this.InfoItem('总功率', this.systemInfo.systemLoad)
        this.InfoItem('运行率', this.systemInfo.runningStatus)
        this.InfoItem('故障率', this.systemInfo.faultRate)
      }
      .width('100%')
      .backgroundColor('#eff6ff')
      .padding(10)

      // 今日统计区
      Column({ space: 6 }) {
        Text('今日统计')
          .fontSize(13)
          .width('100%')
          .textAlign(TextAlign.Start)
          .margin({bottom:5})
        this.InfoItem('启动次数', this.systemInfo.todayStartCount + '次')
        this.InfoItem('平均负载', this.systemInfo.averageLoad)
        this.InfoItem('能耗', this.systemInfo.power)
      }
      .width('100%')
      .backgroundColor('#fefce8')
      .padding(10)
    }
    .height('80%')
    .borderRadius(6)
  }

  @Builder
  InfoItem(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize(12)
        .fontColor('#496ddc')
      Text(value)
        .fontSize(12)
        .fontColor('#496ddc')
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }
}