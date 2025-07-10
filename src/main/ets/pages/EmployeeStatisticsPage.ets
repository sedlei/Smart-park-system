interface TabData {
  title: string
}

interface EmployeeActivity {
  name: string
  id: string
  time: string
  date: string
}

interface EmployeeStats {
  total: number
  active: number
  inactive: number
  today: number
}

@ComponentV2
export struct EmployeeStatisticsPage {

  @Local employeeStatus: EmployeeStats = {
    total: 3,
    active: 2,
    inactive: 1,
    today: 2
  }

  @Local recentActivities: EmployeeActivity[] = [
    { name: '李四', id: 'EMP002', time: '09:15:00', date: '2024-01-15' },
    { name: '张三', id: 'EMP001', time: '08:30:00', date: '2024-01-15' },
    { name: '王五', id: 'EMP003', time: '17:45:00', date: '2024-01-10' }
  ]

  build() {
    Row({ space: 15 }) {
      // 员工统计卡片
      Column() {
        Text('员工统计')
          .fontSize(20)
          .fontWeight('bold')
          .width('100%')
          .textAlign(TextAlign.Start)
          .margin({ bottom: 20 })

        Grid() {
          // 总员工数
          GridItem() {
            Column() {
              Text(this.employeeStatus.total.toString())
                .fontSize(24)
                .fontColor('#0000FF')
                .fontWeight('bold')
              Text('总员工数')
                .fontSize(14)
                .margin({ top: 5 })
            }
            .backgroundColor('#F5F5FF')
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)
          }

          // 正常员工
          GridItem() {
            Column() {
              Text(this.employeeStatus.active.toString())
                .fontSize(24)
                .fontColor('#00FF00')
                .fontWeight('bold')
              Text('正常员工')
                .fontSize(14)
                .margin({ top: 5 })
            }
            .backgroundColor('#F5FFF5')
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)
          }

          // 锁定员工
          GridItem() {
            Column() {
              Text(this.employeeStatus.inactive.toString())
                .fontSize(24)
                .fontColor('#FF0000')
                .fontWeight('bold')
              Text('锁定员工')
                .fontSize(14)
                .margin({ top: 5 })
            }
            .backgroundColor('#FFF5F5')
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)
          }

          // 今日进入
          GridItem() {
            Column() {
              Text(this.employeeStatus.today.toString())
                .fontSize(24)
                .fontColor('#FFD700')
                .fontWeight('bold')
              Text('今日进入')
                .fontSize(14)
                .margin({ top: 5 })
            }
            .backgroundColor('#FFFFF5')
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)
          }
        }
        .columnsTemplate('1fr 1fr')
        .rowsTemplate('1fr 1fr')
        .columnsGap(10)
        .rowsGap(10)
        .width('100%')
        .height(200)
      }
      .height('100%')
      .layoutWeight(1)
      .padding(20)
      .borderRadius(10)
      .backgroundColor(Color.White)
      .shadow({
        radius: 6,
        color: '#1F000000',
        offsetX: 2,
        offsetY: 4
      })

      // 最近活动列表
      Column() {
        Text('最近活动')
          .fontSize(20)
          .fontWeight('bold')
          .width('100%')
          .textAlign(TextAlign.Start)
          .margin({ bottom: 20 })

        List({ space: 3 }) {
          ForEach(this.recentActivities, (activity: EmployeeActivity) => {
            ListItem() {
              Row() {
                Column() {
                  Text(activity.name)
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                  Text(activity.id)
                    .fontSize(14)
                    .fontColor('#666666')
                }
                .alignItems(HorizontalAlign.Start)

                Column() {
                  Text(activity.time)
                    .fontSize(16)
                  Text(activity.date)
                    .fontSize(14)
                    .fontColor('#666666')
                }
                .alignItems(HorizontalAlign.End)
              }
              .width('100%')
              .padding(10)
              .justifyContent(FlexAlign.SpaceBetween)
              .border({ width: 1, color: '#E6E6E6', radius: 8 })
            }
          })
        }
        .width('100%')
        .height('85%')
        .padding(10)
        .backgroundColor('#ffffff')
        .border({ width: 1, color: '#E0E0E0', radius: 5 })
      }
      .height('100%')
      .layoutWeight(1)
      .padding(20)
      .borderRadius(10)
      .backgroundColor(Color.White)
      .shadow({
        radius: 6,
        color: '#1F000000',
        offsetX: 2,
        offsetY: 4
      })
    }
    .width('100%')
    .height('100%')
    .padding({ top: 10, right: 20, bottom: 20, left: 20 })
    .backgroundColor('#F5F5F5')
  }
}