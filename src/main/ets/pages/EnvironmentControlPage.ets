

@ComponentV2
export struct EnvironmentControlPage {
  // 窗帘电控
  @Local curtainStatus: boolean = false

  // 照明控制
  @Local mainLight: boolean = false
  @Local auxLight: boolean = false
  @Local nightLight: boolean = true
  @Local bright: number = 80
  @Local autoLight: boolean = false

  // 设备状态
  @Local lightSysStatus: string = '正常'
  @Local curtainSysStatus: string = '正常'
  @Local netStatus: string = '稳定'

  build() {
    Row({ space: 16 }) {
      // 窗帘电控
      Column({ space: 15 }) {
        // 标题行
        Row({ space: 5 }) {
          Image($r('app.media.icon_curtain'))
            .width(25)
            .height(25)
          Text('窗帘电控')
            .fontSize(18).fontWeight(FontWeight.Bold)
            .margin({ bottom: 12 })
        }
        .width('100%')
        .height(20)
        //.backgroundColor('#37C3D5')

        // 窗帘状态行
        Row() {
          Text('窗帘状态')
          Text(this.curtainStatus == true ? '已开启' : '已关闭')
            .fontColor(this.curtainStatus ? '#69BC6D' :'#F56C6C')
            .backgroundColor(this.curtainStatus ? '#E8F5E9' :'#FDE2E2')
            .padding({ left: 8, right: 8, top: 2, bottom: 2 })
            .borderRadius(8)
        }
        .width('100%')
        //.backgroundColor('#37C3D5')
        .justifyContent(FlexAlign.SpaceBetween)

        Blank()

        // 窗帘控制列
        Column({ space: 12 }) {
          Button('打开窗帘')
            .width('100%')
            .type(ButtonType.Capsule)
            .backgroundColor(this.curtainStatus ? '#222B45' : '#fff')
            .fontColor(this.curtainStatus ? '#fff' : '#222B45')
            .borderWidth(1)
            .borderColor('#E4E4E4')
            .onClick(() => {
              this.curtainStatus = true
            })
          Button('关闭窗帘')
            .width('100%')
            .type(ButtonType.Capsule)
            .backgroundColor(!this.curtainStatus ? '#222B45' : '#fff')
            .fontColor(!this.curtainStatus ? '#fff' : '#222B45')
            .borderWidth(1)
            .borderColor('#E4E4E4')
            .onClick(() => {
              this.curtainStatus = false
            })
        }
        .width('100%')
        //.backgroundColor('#37C3D5')
      }
      .height('100%')
      .width('32%')
      .backgroundColor('#ffffff')
      .borderRadius(12)
      .shadow({ radius: 6, color: '#1F000000', offsetX: 2, offsetY: 4 })
      .padding(20)

      // 照明控制
      Column({ space: 15 }) {
        // 标题行
        Row() {
          Image($r('app.media.icon_light'))
            .width(25)
            .height(25)
          Text('照明控制')
            .fontSize(18).fontWeight(FontWeight.Bold)
            .margin({ bottom: 12 })
        }
        .width('100%')
        .height(20)

        // 控制区
        Column({ space: 12 }) {
          this.LightingSwitchItem('主照明', this.mainLight, (isOn: boolean) => this.mainLight = isOn)
          this.LightingSwitchItem('二路开关', this.auxLight, (isOn: boolean) => this.auxLight = isOn)
          this.LightingSwitchItem('白天关灯', this.nightLight, (isOn: boolean) => this.nightLight = isOn)
        }
        .width('100%')

        Blank();

        // 亮度区
        Column({ space: 0 }) {
          Row() {
            Text('亮度: ' + this.bright + '%')
              .fontSize(16)
          }
          .width('100%')

          Slider({
            value: this.bright,
            min: 0,
            max: 100,
            step: 1,
            style: SliderStyle.OutSet
          })
            .selectedColor('#0A59F7')
            //.backgroundColor('#F9C227')
            .width('100%')
            .onChange((value: number) => {
              this.bright = value
            })
        }
        //.backgroundColor('#26A9CF')
      }
      .height('100%')
      .width('32%')
      .backgroundColor('#ffffff')
      .borderRadius(12)
      .shadow({ radius: 6, color: '#1F000000', offsetX: 2, offsetY: 4 })
      .padding(20)

      // 设备状态
      Column({ space: 15 }) {
        // 标题行
        Row() {
          Image($r('app.media.icon_setting'))
            .width(25)
            .height(25)
          Text('设备状态')
            .fontSize(18).fontWeight(FontWeight.Bold)
        }
        .width('100%')

        // 内容项
        Column() {
          this.StatusItem('窗帘系统', this.curtainSysStatus)
          this.StatusItem('照明系统', this.lightSysStatus)
          this.StatusItem('网络连接', this.netStatus)
        }
      }
      .height('100%')
      .width('32%')
      .backgroundColor('#fff')
      .borderRadius(12)
      .shadow({ radius: 6, color: '#1F000000', offsetX: 2, offsetY: 4 })
      .padding(20)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F6FA')
    .padding(16)//16
    .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP,SafeAreaEdge.BOTTOM])

  }

  @Builder
  StatusItem(title: string, status: string) {
    Row() {
      Text(title)
        .fontSize(13)
      Blank()
      Text(status)
        .fontColor('#4CAF50')
        .backgroundColor('#E8F5E9')
        .padding({ left: 8, right: 8, top: 2, bottom: 2 })
        .borderRadius(8)
    }
    .width('100%')
    .padding(8)
    .margin({ bottom: 8 })
    .borderRadius(8)
    .border({ width: 1, color: '#E8E8E8' })
  }

  @Builder
  LightingSwitchItem(title: string, isOn: boolean, onChange: (isOn: boolean) => void) {
    Row() {
      Text(title)
        .fontSize(16)
      Blank()
      Toggle({ type: ToggleType.Switch, isOn: isOn })
        .onChange(onChange)
    }
    .width('100%')
    .padding({ left: 4, right: 4 })
  }
}