

@ComponentV2
export struct SystemControl {
  // 系统配置
  @Local systemConfig: number = 5
  @Local currentSeconds: number = 5
  @Local inputSeconds: string = this.systemConfig.toString()

  // 系统信息
  @Local version: string = 'v2.1.0'
  @Local runtime: string = '72h 15m'
  @Local day: string = '3'

  // 网络状态
  @Local ip: string = '192.168.1.100'
  @Local gateway: string = '192.168.1.1'
  @Local status: string = '正常'

  @Local selectedIndex: number = 0;
  options: Array<SelectOption> = [
    { value: "选项一" },
    { value: "选项二" },
    { value: "选项三" }
  ];

  build() {
    Column({ space: 10 }) {
      // 顶部三个信息块
      Row({ space: 10 }) {
        // 系统配置
        Column({ space: 10 }) {
          // 标题行
          Row() {
            Image($r('app.media.icon_setting'))
              .width(24)
              .height(24)
            Text('系统配置')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
          }
          .width('100%')

          // 参数设置行
          Row({ space: 5 }) {
            TextInput()
              .height(28)
              .layoutWeight(1)
              .fontSize(20)
              .type(InputType.Number)
              .border({ width: 1, color: '#E0E0E0', radius: 5 })
              .onChange((value: string) => {
                this.inputSeconds = value
              })
            Button('更新', { type: ButtonType.Normal, stateEffect: true })
              .height(28)
              .layoutWeight(1)
              .borderRadius(5)
              .backgroundColor('#1976D2')
              .fontColor('#fff')
              .onClick(() => {})
          }
          .width('70%')

          // 参数显示行
          Text('当前: ' + this.currentSeconds + '秒')
            .fontSize(14)
        }
        .height('100%')
        .layoutWeight(1)
        .padding(15)
        .borderRadius(8)
        .backgroundColor('#FFFFFF')
        .shadow({
          radius: 6,
          color: '#1F000000',
          offsetX: 2,
          offsetY: 4
        })

        // 系统信息
        Column({ space: 5 }) {
          // 标题行
          Row() {
            Image($r('app.media.icon_database'))
              .width(24)
              .height(24)
            Text('系统信息')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
          }
          .width('100%')

          // 内容列
          Column() {
            this.InfoItem('版本:', this.version)
            this.InfoItem('运行:', this.runtime)
            this.InfoItem('重启:', this.day,)
          }
        }
        .height('100%')
        .layoutWeight(1)
        .padding(15)
        .borderRadius(8)
        .backgroundColor('#FFFFFF')
        .shadow({
          radius: 6,
          color: '#1F000000',
          offsetX: 2,
          offsetY: 4
        })

        // 网络状态
        Column({ space: 5 }) {
          // 标题行
          Row() {
            Image($r('app.media.icon_wifi'))
              .width(24)
              .height(24)
            Text('网络状态')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
          }
          .width('100%')

          // 内容列
          Column() {
            this.InfoItem('IP:', this.ip)
            this.InfoItem('网关:', this.gateway)
            this.StatusItem('状态:', this.status)
          }
        }
        .height('100%')
        .layoutWeight(1)
        .padding(15)
        .borderRadius(8)
        .backgroundColor('#FFFFFF')
        .shadow({
          radius: 6,
          color: '#1F000000',
          offsetX: 2,
          offsetY: 4
        })
      }
      .width('100%')
      .height('33%')

      // 连接方式行
      Row({ space: 10 }){
        // 串口操作区
        Column({ space: 10 }) {
          // 标题行
          Row() {
            Image($r('app.media.icon_cable'))
              .width(24)
              .height(24)
            Text('串口直连（控制面板）')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
            Blank()
            Text('已连接')
              .fontSize(12)
              .fontColor('#666666')
              .textAlign(TextAlign.Center)
              .padding(3)
              .borderRadius(8)
              .backgroundColor('#0F172A')
          }
          .width('100%')
          //.backgroundColor('#2CC2DE')

          // 串口与波特率行
          Row({ space: 10 }) {
            // 串口区
            Column({ space: 3 }) {
              // COM选择
              Text('串口')
                .width('100%')
                .fontSize(13)
                .textAlign(TextAlign.Start)
              Select(this.options)
                .width('100%')
                .constraintSize({ minHeight: 25 })
                .height(25)
                .border({ width: 1, color: '#DFDFDF', radius: 5 })
                .backgroundColor('#ffffff')
                .selected(this.selectedIndex)
                .value("请选择")
                .onSelect((index: number) => {
                  this.selectedIndex = index;
                  console.info(
                    'Select: index is ' + index +
                      ', value is ' + this.options[index].value
                  );
                })
            }
            .layoutWeight(1)
            //.backgroundColor('#FFDA47')

            // 波特率区
            Column({ space: 3 }) {
              // COM选择
              Text('波特率')
                .width('100%')
                .fontSize(13)
                .textAlign(TextAlign.Start)
              Select(this.options)
                .width('100%')
                .constraintSize({ minHeight: 25 })
                .height(25)
                .border({ width: 1, color: '#DFDFDF', radius: 5 })
                .backgroundColor('#ffffff')
                .selected(this.selectedIndex)
                .value("请选择")
                .onSelect((index: number) => {
                  this.selectedIndex = index;
                  console.info(
                    'Select: index is ' + index +
                      ', value is ' + this.options[index].value
                  );
                })
            }
            .layoutWeight(1)
            //.backgroundColor('#FFDA47')
          }
          .width('100%')
          //.backgroundColor('#2CC2DE')

          // 数据位停止位与校验位行
          Row({ space: 5 }) {
            // 数据位
            Column({ space: 3 }) {
              // COM选择
              Text('数据位')
                .width('100%')
                .fontSize(13)
                .textAlign(TextAlign.Start)
              Select(this.options)
                .width('100%')
                .constraintSize({ minHeight: 25 })
                .height(25)
                .border({ width: 1, color: '#DFDFDF', radius: 5 })
                .backgroundColor('#ffffff')
                .selected(this.selectedIndex)
                .value("请选择")
                .onSelect((index: number) => {
                  this.selectedIndex = index;
                  console.info(
                    'Select: index is ' + index +
                      ', value is ' + this.options[index].value
                  );
                })
            }
            .layoutWeight(1)
            //.backgroundColor('#FFDA47')

            // 停止位
            Column({ space: 3 }) {
              // COM选择
              Text('停止位')
                .width('100%')
                .fontSize(13)
                .textAlign(TextAlign.Start)
              Select(this.options)
                .width('100%')
                .constraintSize({ minHeight: 25 })
                .height(25)
                .border({ width: 1, color: '#DFDFDF', radius: 5 })
                .backgroundColor('#ffffff')
                .selected(this.selectedIndex)
                .value("请选择")
                .onSelect((index: number) => {
                  this.selectedIndex = index;
                  console.info(
                    'Select: index is ' + index +
                      ', value is ' + this.options[index].value
                  );
                })
            }
            .layoutWeight(1)
            //.backgroundColor('#FFDA47')

            // 校验位
            Column({ space: 3 }) {
              // COM选择
              Text('校验位')
                .width('100%')
                .fontSize(13)
                .textAlign(TextAlign.Start)
              Select(this.options)
                .width('100%')
                .constraintSize({ minHeight: 25 })
                .height(25)
                .border({ width: 1, color: '#DFDFDF', radius: 5 })
                .backgroundColor('#ffffff')
                .selected(this.selectedIndex)
                .value("请选择")
                .onSelect((index: number) => {
                  this.selectedIndex = index;
                  console.info(
                    'Select: index is ' + index +
                      ', value is ' + this.options[index].value
                  );
                })
            }
            .layoutWeight(1)
            //.backgroundColor('#FFDA47')
          }
          .width('100%')
          //.backgroundColor('#2CC2DE')

          Blank();

          // 操作按钮
          Button('断开连接', {
            stateEffect: true                  // 保留按压态
          })
            .width('100%')                     // 宽度撑满父容器
            .height(30)                        // 高度 48px
            .backgroundColor('#EF4444')        // 红色背景
            .fontColor(Color.White)            // 白色文字
            .fontSize(16)                      // 文字大小 16px
            .borderRadius(8)                   // 圆角 8px
            .onClick(() => {
              console.log('断开连接按钮被点击');
            });
        }
        .height('100%')
        .layoutWeight(1)
        .padding(20)
        .borderRadius(8)
        .backgroundColor('#ffffff')
        .shadow({
          radius: 6,
          color: '#1F000000',
          offsetX: 2,
          offsetY: 4
        })

        // MQTT操作区
        Column({ space: 10 }) {
          // 标题行
          Row() {
            Image($r('app.media.icon_phone'))
              .width(24)
              .height(24)
              Text('MQTT连接（手机APP）')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
            Blank()
            Text('已连接')
              .fontSize(12)
              .fontColor('#666666')
              .textAlign(TextAlign.Center)
              .padding(3)
              .borderRadius(8)
              .backgroundColor('#0F172A')
          }
          .width('100%')
          //.backgroundColor('#2CC2DE')

          // 服务器地址和端口行
          Row({ space: 10 })
          {
            // 服务器地址
            Column({ space: 3 }) {
              Text('服务器地址')
                .fontSize(13)
                .textAlign(TextAlign.Start)
                .width('100%')
              TextInput({
                placeholder: '请输入内容',
              })
                .width('100%')
                .height(30)
                .placeholderFont({ size: 13 })
                .borderRadius(5)
                .fontSize(13)
                .onChange((value: string) => {
                  console.log('当前输入：', value);
                });
            }
            .layoutWeight(1)

            // 服务器端口
            Column({ space: 3 }) {
              Text('服务器端口')
                .fontSize(13)
                .textAlign(TextAlign.Start)
                .width('100%')
              TextInput({
                placeholder: '请输入内容',
              })
                .width('100%')
                .height(30)
                .placeholderFont({ size: 13 })
                .borderRadius(5)
                .fontSize(13)
                .onChange((value: string) => {
                  console.log('当前输入：', value);
                });
            }
            .layoutWeight(1)
          }
          .width('100%')

          Blank();

          // 操作按钮
          Button('连接MQTT', {
            stateEffect: true                  // 保留按压态
          })
            .width('100%')                     // 宽度撑满父容器
            .height(30)                        // 高度 48px
            .backgroundColor('#0F172A')        // 红色背景
            .fontColor(Color.White)            // 白色文字
            .fontSize(16)                      // 文字大小 16px
            .borderRadius(8)                   // 圆角 8px
            .onClick(() => {
              console.log('断开连接按钮被点击');
            });
        }
        .height('100%')
        .layoutWeight(1)
        .padding(20)
        .borderRadius(8)
        .backgroundColor('#ffffff')
        .shadow({
          radius: 6,
          color: '#1F000000',
          offsetX: 2,
          offsetY: 4
        })

      }
      .width('100%')
      .layoutWeight(1)
      //.backgroundColor('#25C0D1')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .padding(10)
  }

  @Builder
  InfoItem(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize(14)
        .fontColor('#666666')
      Blank()  // 添加弹性空间
      Text(value)
        .fontSize(14)
    }
    .width('100%')
    .margin({ top: 4 })
  }

  @Builder
  StatusItem(label: string, status: string) {
    Row() {
      Text(label)
        .fontSize(14)
        .fontColor('#666666')
      Blank()  // 添加弹性空间
      Row() {
        Circle({ width: 8, height: 8 })
          .fill(status === '正常' ? '#4CAF50' : '#FF9800')
          .margin({ right: 4 })
        Text(status)
          .fontSize(14)
      }
    }
    .width('100%')
    .margin({ top: 4 })
  }
}


// // 系统状态部分（使用Scroll组件实现滑动效果）
// Column() {
//   Row() {
//     Image($r('app.media.icon_door_open'))
//       .width(24)
//       .height(24)
//     Text('系统状态')
//       .fontSize(16)
//       .fontWeight(FontWeight.Bold)
//       .margin({ left: 8 })
//   }
//   .width('100%')
//   .padding({ left: 16, right: 16, top: 16, bottom: 8 })
//
//   Scroll() {
//     Column() {
//       // 门禁系统
//       this.StatusBlock('门禁系统', this.accessControlStatus,
//         '读卡器: ' + this.accessControlReading)
//
//       // 环境监控
//       this.StatusBlock('环境监控', this.environmentStatus,
//         '传感器: ' + this.environmentSensors)
//
//       // 报警系统
//       this.StatusBlock('报警系统', this.alarmStatus,
//         '警报器: ' + this.alarmDevices)
//
//       // 数据存储
//       this.StatusBlock('数据存储', this.storageStatus,
//         '使用率: ' + this.storageUsage)
//     }
//     .padding(10)
//   }
//   .scrollBar(BarState.Auto)
//   .scrollable(ScrollDirection.Vertical)
//   .edgeEffect(EdgeEffect.Spring)
// }
// .height('50%')