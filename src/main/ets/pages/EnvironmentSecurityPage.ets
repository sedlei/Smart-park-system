import { EnvironmentMonitoringPage } from  './EnvironmentMonitoringPage';
import { DoorAccessControlPage } from  './DoorAccessControlPage';
import { SecurityOverviewPage } from  './SecurityOverviewPage';

interface Tab {
  title: string;
  icon: Resource;
}

@ComponentV2
export struct EnvironmentSecurityPage {
  private swiperCtrl: SwiperController = new SwiperController()
  @Local currentIndex: number = 0;
  tabs: Tab[] = [
    { title: "环境监控", icon: $r("app.media.icon_home") },
    { title: "门禁控制", icon: $r("app.media.icon_environment_setting") },
    { title: "安全总览", icon: $r("app.media.icon_device") },
  ];

  private onSwiperChange(newIndex: number): void {
    this.currentIndex = newIndex;
  }

  build() {
    Column() {
      // 自定义TAB标签行
      Row({ space: 5 }) {
        ForEach(this.tabs, (item: Tab, index: number) => {
          Row() {
            Text(item.title)
              .fontSize(14)
              .fontColor(index == this.currentIndex ? '#000000' : '#7C8A9D')
          }
          .height('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .borderRadius(this.currentIndex == index ? 8 : 0)
          .backgroundColor(index == this.currentIndex ? '#FFFFFF' : '#F1F5F9')
          .shadow(
            this.currentIndex === index
              ? {
              radius: 8,
              color: '#1F000000',
              offsetX: 4,
              offsetY: 4
            }
              : undefined
          )
          .onTouch((e: TouchEvent) => {
            if (e.type === TouchType.Up) {
              console.log('touch up at tab', index);
              this.currentIndex = index;
              this.swiperCtrl.changeIndex(index, true);
            }
          });
        })
      }
      .width('95%')
      .height('10%')
      .padding(5)
      .margin({ top: 5 })
      .borderRadius(8)
      .clip(true)
      .backgroundColor('#F0F4F8')

      // 内容区域
      Swiper(this.swiperCtrl) {
        EnvironmentMonitoringPage().flexGrow(1);
        DoorAccessControlPage().flexGrow(1);
        SecurityOverviewPage().flexGrow(1);
      }
      .width('100%')
      .height('90%')
      .loop(false)
      .disableSwipe(false)
      .indicator(false)
      .onChange(this.onSwiperChange.bind(this))
      .duration(400)
      .curve(Curve.FastOutSlowIn);
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}

