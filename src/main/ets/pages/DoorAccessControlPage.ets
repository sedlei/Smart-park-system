// 实时监控状态接口
interface MonitoringStatus {
  imageStatus: string
  currentPeople: number
  accessType: string
  calcType: string
}

// 门禁记录接口
interface AccessRecord {
  time: string
  user: string
  action: string
  type: string
}

// 系统状态接口
interface DoorStatus {
  isOpen: boolean
  autoCloseTime: number
  verifyMethod: string
  workTime: string
  isLocked: boolean
}

// 标签页数据接口
interface TabData {
  title: string
  icon: Resource
}

@ComponentV2
export struct DoorAccessControlPage {

  @Local monitoringStatus: MonitoringStatus = {
    imageStatus: '正常',
    currentPeople: 3,
    accessType: '人脸识别',
    calcType: '无异常'
  }

  @Local doorStatus: DoorStatus = {
    isOpen: false,
    autoCloseTime: 10,
    verifyMethod: '刷卡+指纹',
    workTime: '06:00-22:00',
    isLocked: false
  }

  @Local accessRecords: AccessRecord[] = [
    { time: '08:30:15', user: '张三', action: '进入', type: '正常' },
    { time: '09:15:22', user: '李四', action: '进入', type: '指纹' },
    { time: '12:45:33', user: '王五', action: '离开', type: '刷卡' },
    { time: '12:45:33', user: '王五', action: '离开', type: '刷卡' },
    { time: '12:45:33', user: '王五', action: '离开', type: '刷卡' },
    { time: '12:45:33', user: '王五', action: '离开', type: '刷卡' },
    { time: '14:20:18', user: '赵六', action: '进入', type: '人脸' }
  ]

  build() {
      Row({ space: 10 }) {
        // 左侧门禁控制面板
        Column({ space: 10 }) {
          // 标题行
          Row({ space: 5 }) {
            Image($r('app.media.icon_door_close'))
              .width(20)
              .height(20)
            Text('门禁控制面板')
              .fontSize(13)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)
          }
          .width('100%')
          .height(30)

          // 图标和状态显示区
          Row({ space: 10 }) {
            Column() {
              Image($r('app.media.icon_door_close'))
                .width('70%')
                .height('70%')
            }
            .width(80)
            .height(80)
            .borderWidth(3)
            .borderColor('#9CA3AF')
            .borderRadius(40)
            .backgroundColor('#F3F4F6')
            .justifyContent(FlexAlign.Center)

            Text(this.doorStatus.isOpen == true ? '大门已打开' : '大门已关闭')
              .width(100)
              .height(25)
              .fontSize(13)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Center)
              .borderRadius(10)
              .backgroundColor('#F1F5F9')
          }
          .width('100%')
          .padding(15)
          .borderRadius(8)
          .justifyContent(FlexAlign.Center)
          .backgroundColor('#F9FAFB')

          // 门锁状态行
          Row() {
            // 文本区域
            Row({ space: 5 }) {
              Image($r('app.media.icon_lock_red'))
                .width(20)
                .height(20)
              Text('锁定门禁')
                .fontSize(13)
            }

            // 按钮区域
            Toggle({ type: ToggleType.Switch, isOn: this.doorStatus.isLocked })
              .width(50)
              .height(25)
              .onChange((value: boolean) => {
                this.doorStatus.isLocked = value;
              });
          }
          .width('100%')
          .padding(10)
          .borderWidth(1)
          .borderColor('#E9EEF4')
          .justifyContent(FlexAlign.SpaceBetween)

          Blank()

          // 控制按钮
          Row({ space: 15 }) {
            Button('开门')
              .width(150)
              .height(30)
              .backgroundColor(this.doorStatus.isOpen ? '#E0E0E0' : '#2196F3')
              .onClick(() => this.doorStatus.isOpen = true)
            Button('关门')
              .width(150)
              .height(30)
              .backgroundColor(!this.doorStatus.isOpen ? '#E0E0E0' : '#2196F3')
              .onClick(() => this.doorStatus.isOpen = false)
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')
        }
        .height('100%')
        .layoutWeight(1)
        .padding(20)
        .borderRadius(8)
        .backgroundColor('#FFFFFF')
        .shadow({ radius: 6, color: '#1F000000', offsetX: 2, offsetY: 4 })

        // 右侧内容区域
        Column({ space: 10 }) {
          // 标题行
          Row({ space: 5 }) {
            Image($r('app.media.icon_camera_green'))
              .width(20)
              .height(20)
            Text('门禁记录')
              .fontSize(13)
              .fontWeight(FontWeight.Bold)
          }
          .width('100%')
          .height(25)

          // 概览区
          Column({ space: 5 }) {
            // 标题行
            Row({ space: 5 }) {
              Circle({ width: 8, height: 8 })
                .fill('#4CAF50')
              Text('实时监控')
                .fontSize(12)
                .fontColor('#666666')
            }
            .width('100%')
            .height(15)

            //.backgroundColor('#307990')

            // 监控状态内容
            Row({ space: 70 }) {
              Column({ space: 5 }) {
                Row({ space: 4 }) {
                  Text('摄像头状态:')
                    .fontSize(12)
                    .fontColor('#666666')
                  Text(this.monitoringStatus.imageStatus)
                    .fontSize(12)
                    .fontColor('#4CAF50')
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .width('100%')

                Row({ space: 4 }) {
                  Text('当前人数:')
                    .fontSize(12)
                    .fontColor('#666666')
                  Text(this.monitoringStatus.currentPeople + '人')
                    .fontSize(12)
                    .fontColor('#4CAF50')
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .width('100%')
              }
              .layoutWeight(1)

              Column({ space: 5 }) {
                Row({ space: 4 }) {
                  Text('人脸识别:')
                    .fontSize(12)
                    .fontColor('#666666')
                  Text(this.monitoringStatus.accessType)
                    .fontSize(12)
                    .fontColor('#4CAF50')
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .width('100%')

                Row({ space: 4 }) {
                  Text('异常统计:')
                    .fontSize(12)
                    .fontColor('#666666')
                  Text(this.monitoringStatus.calcType)
                    .fontSize(12)
                    .fontColor('#4CAF50')
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .width('100%')
              }
              .layoutWeight(1)
            }
            .width('100%')
          }
          .width('100%')
          .padding(12)
          .borderWidth(1)
          .borderColor('#CAF8DA')
          .backgroundColor('#f0fdf4')
          .borderRadius(8)

          // 今日进出记录区
          Column({ space: 5 }) {
            // 标题行
            Row() {
              Text('今日进出记录')
                .fontSize(12)
                .fontColor('#666666')
            }
            .width('100%')
            .height(15)

            // 记录列表
            List() {
              ForEach(this.accessRecords, (record: AccessRecord) => {
                ListItem() {
                  Row() {
                    Row({ space: 4 }) {
                      Circle({ width: 6, height: 6 })
                        .fill(record.action === '进入' ? '#4CAF50' : '#FF5252')
                      Text(record.user)
                        .fontSize(12)
                    }

                    Column({ space: 2 }) {
                      Text(record.time)
                        .fontSize(12)
                      Text(record.action + ' · ' + record.type)
                        .fontSize(10)
                        .fontColor('#666666')
                    }
                  }
                  .width('100%')
                  .justifyContent(FlexAlign.SpaceBetween)
                  .padding({ top: 8, bottom: 8 })
                }
              })
            }
            .width('100%')
            .height('100%')
            .scrollBar(BarState.Off)
            .divider({ strokeWidth: 1, color: '#F5F5F5' })
          }
          .width('100%')
          .height('55%')
          .clip(true)
        }
        .height('100%')
        .layoutWeight(1)
        .padding(20)
        .borderRadius(8)
        .backgroundColor('#FFFFFF')
        .shadow({ radius: 6, color: '#1F000000', offsetX: 2, offsetY: 4 })
      }
      .width('100%')
      .height('100%')
      .padding({ top:5, right:16, bottom:16, left:16 })
      .backgroundColor('#F5F5F5')
  }
}




// // 门禁设置
// Column({ space: 6 }) {
//   Text('门禁设置')
//     .fontSize(12)
//     .fontWeight(FontWeight.Medium)
//
//   Row({ space: 8 }) {
//     Text('自动关闭时间:')
//       .fontSize(12)
//       .fontColor('#1e40af')
//     Text(this.doorStatus.autoCloseTime + '秒')
//       .fontSize(12)
//       .fontColor('#1e40af')
//   }
//   .justifyContent(FlexAlign.SpaceBetween)
//   .width('100%')
//
//   Row({ space: 8 }) {
//     Text('验证方式:')
//       .fontSize(12)
//       .fontColor('#1e40af')
//     Text(this.doorStatus.verifyMethod)
//       .fontSize(12)
//       .fontColor('#1e40af')
//   }
//   .justifyContent(FlexAlign.SpaceBetween)
//   .width('100%')
//
//   Row({ space: 8 }) {
//     Text('工作时间:')
//       .fontSize(12)
//       .fontColor('#1e40af')
//     Text(this.doorStatus.workTime)
//       .fontSize(12)
//       .fontColor('#1e40af')
//   }
//   .justifyContent(FlexAlign.SpaceBetween)
//   .width('100%')
// }
// .padding(8)
// .width('100%')
// .backgroundColor('#ff8e9ea7')
// .borderRadius(3)