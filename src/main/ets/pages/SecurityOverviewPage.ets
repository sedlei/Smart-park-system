// 标签页数据接口
interface TabData {
  title: string
  icon: Resource
}

@ComponentV2
export struct SecurityOverviewPage {
  // 环境安全相关状态
  @Local environmentSafe: boolean = true;
  @Local temperatureControl: string = '正常';
  @Local humidityControl: string = '正常';
  @Local energySaving: string = '正常';
  @Local airQuality: string = '正常';

  // 门禁安全相关状态
  @Local doorSecurity: boolean = true;
  @Local mainDoor: string = '已关闭';
  @Local sideDoor: string = '已锁定';
  @Local windowSystem: string = '正常';
  @Local livingSystem: string = '无人';

  // 安全统计相关状态
  @Local safetyCount: number = 0;
  @Local doorAlarmCount: number = 4;
  @Local monitoringTime: number = 24;
  @Local systemScore: number = 99.9;

  build() {
    Row({ space: 10 }) {
      // 环境安全区域
      Column({ space: 10 }) {
        // 标题行
        Row({ space: 5 }){
          Image($r('app.media.icon_security'))
            .width(20)
            .height(20)
          Text('环境安全')
            .fontSize(14)
            .width('100%')
            .fontWeight('bold')
            .textAlign(TextAlign.Start)
        }
        .width('100%')
        .height(20)

        this.buildStatusItem('温度监控', this.temperatureControl,$r('app.media.icon_thermometer_red'))
        this.buildStatusItem('湿度监控', this.humidityControl,$r('app.media.icon_waterdrop'))
        this.buildStatusItem('烟雾检测', this.airQuality,$r('app.media.icon_smokeSensor'))
        this.buildStatusItem('气体检测', this.energySaving, $r('app.media.icon_flame'))
      }
      .height('100%')
      .layoutWeight(1)
      .padding(15)
      .backgroundColor('#ffffff')
      .borderRadius(10)
      .shadow({ radius: 6, color: '#1F000000', offsetX: 2, offsetY: 4 })

      // 门禁安全区域
      Column({ space: 10 }) {
        // 标题行
        Row({ space: 5 }){
          Image($r('app.media.icon_lock_blue'))
            .width(18)
            .height(18)
          Text('门禁安全')
            .fontSize(14)
            .fontWeight('bold')
            .width('100%')
            .textAlign(TextAlign.Start)
        }


        this.buildStatusItem('大门状态', this.mainDoor,$r('app.media.icon_door_close'))
        this.buildStatusItem('门锁状态', this.sideDoor,$r('app.media.icon_lock_red'))
        this.buildStatusItem('窗控系统', this.windowSystem,$r('app.media.icon_camera_green'))
      }
      .height('100%')
      .layoutWeight(1)
      .padding(15)
      .backgroundColor('#ffffff')
      .borderRadius(10)
      .shadow({ radius: 6, color: '#1F000000', offsetX: 2, offsetY: 4 })

      // 安全统计区域
      Column({ space: 10 }) {
        // 标题行
        Row({ space: 5 }) {
          Image($r('app.media.icon_warning'))
            .width(20)
            .height(20)
          Text('安全统计')
            .fontSize(14)
            .fontWeight('bold')
            .width('100%')
            .textAlign(TextAlign.Start)
        }

        // 数据块
        Column({ space: 5 }) {
          // 内容块1
          Row({ space: 5 }) {
            this.buildStatItem('安全事件', this.safetyCount.toString(), '#F0FDF4','#18AE8B')
            this.buildStatItem('门禁记录', this.doorAlarmCount.toString(), '#EFF6FF','#256CEF')
          }
          .width('100%')
          // 内容块2
          Row({ space: 5 }) {
            this.buildStatItem('监控时长(h)', this.monitoringTime.toString(), '#FEFCE8','#CA9946')
            this.buildStatItem('系统评分(%)', this.systemScore.toString(), '#FAF5FF','#9342EB')
          }
          .width('100%')
        }

        // 安全等级显示
        Column({ space: 10 }) {
          Row({ space: 0 }) {
            Image($r('app.media.icon_security'))
              .width(20)
              .height(20)
              .margin({ right: 8 })
            Text('当前安全等级')
              .fontSize(13)
              .width('100%')
              .textAlign(TextAlign.Start)
          }

          Text('安全')
            .fontSize(13)
            .fontWeight(FontWeight.Bold)
            .fontColor('#4CAF50')
          Text('所有系统运行正常')
            .fontSize(12)
            .fontColor('#757575')
        }
        .width('100%')
        .padding(10)
        .borderRadius(8)
        .backgroundColor('#f0fdf4')
      }
      .height('100%')
      .layoutWeight(1)
      .padding(15)
      .backgroundColor('#ffffff')
      .borderRadius(10)
      .shadow({ radius: 6, color: '#1F000000', offsetX: 2, offsetY: 4 })
    }
    .width('100%')
    .height('100%')
    .padding({ top:5, right:16, bottom:16, left:16 })
    .backgroundColor('#f3f4f6')
  }

  @Builder
  buildStatusItem(title: string, status: string, icon: Resource) {
    Row() {
      Row({ space: 5 }) {
        Image(icon)
          .width(15)
          .height(15)
        Text(title)
          .fontSize(14)
      }
      Text(status)
        .fontSize(14)
        .fontColor(status === '正常' ? '#4CAF50' : status === '已关闭' ? '#FF9800' : '#757575')
    }
    .width('100%')
    //.height(30)
    .padding(10)
    .backgroundColor('#ffffff')
    .justifyContent(FlexAlign.SpaceBetween)
    .border({ width: 1, color: '#E0E0E0', radius:5 })
  }

  @Builder
  buildStatItem(title: string, value: string, bkgC: string, textColor: string) {
    Column() {
      Text(value)
        .fontSize(12)
        .fontWeight(FontWeight.Bold)
        .fontColor(textColor)
      Text(title)
        .fontSize(12)
        .fontColor('#757575')
    }
    .layoutWeight(1)
    .backgroundColor(bkgC)
    .borderRadius(4)
    .padding(10)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  buildQuickActionButton(title: string) {
    Button(title)
      .width('48%')
      .height(26)
      .fontSize(14)
      .fontColor('#666666')
      .backgroundColor('#ffffff')
      .padding({ left: 15, right: 15 })
      .backgroundColor('#ffffff')
      .border({ width: 1, color: '#E0E0E0' })
      .borderRadius(5)
  }
}



// // 快速操作按钮组
// Text('快速操作')
//   .fontSize(12)
//   .fontWeight(FontWeight.Medium)
//   .alignSelf(ItemAlign.Start)
//   .margin({ bottom: 10 })
//
// Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
//   this.buildQuickActionButton('测试警报')
//   this.buildQuickActionButton('系统检查')
//   this.buildQuickActionButton('导出日志')
//   this.buildQuickActionButton('重置警报')
// }
// .width('100%')