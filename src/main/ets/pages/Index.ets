import { HomePage } from './HomePage';
import { EnvironmentControlPage } from  './EnvironmentControlPage';
import { DeviceControlPage } from  './DeviceControlPage';
import { EnvironmentSecurityPage } from  './EnvironmentSecurityPage';
import { EmployeeAdminPage } from './EmployeeAdminPage';
import { SystemControl } from './SystemControl';

  interface Tab {
      title: string;
      icon: Resource;
  }
  
  @Entry
  @ComponentV2
  struct Index {
  // 记录当前悬停的行
  @Local hoverIndex: number = -1;
  // 记录当前选中的行
  @Local selectedIndex: number = 0;
  // 折叠状态
  private collapsed: boolean = true;
  // 是否正在拖拽
  private isDragging: boolean = false;
  // 是否运行侧滑展开
  private disableSwipeOpen: boolean = false;
  // 拖拽偏移量
  private startX: number = 0;
  // 触控时导航栏宽度
  private startWidth: number = 0;
  // 导航栏宽度
  @Local sideBarWidth: number = 200;
  // 导航栏最小宽度
  private menuMinWidth: number = 58;
  // 导航栏最大宽度
  private menuMaxWidth: number = 200;
  // 导航栏自动收缩宽度
  private autoCollapseWidth: number = 100;

  // 菜单项
  tabs: Tab[] = [
    { title: "首页", icon: $r("app.media.icon_home") },
    { title: "环境控制", icon: $r("app.media.icon_environment_setting") },
    { title: "设备控制", icon: $r("app.media.icon_device") },
    { title: "环境安全", icon: $r("app.media.icon_environment_security") },
    { title: "用户管理", icon: $r("app.media.icon_user") },
    { title: "系统状态", icon: $r("app.media.icon_sys") }
  ];

  // 当前页面监听：当进入第三页时关闭菜单栏侧滑
  @Monitor('selectedIndex')
  onSelectedIndexChange(monitor: IMonitor) {
    const newIndex = monitor.value()?.now as number;
    this.disableSwipeOpen = (newIndex === 3 || newIndex === 4);
  }

  // 菜单栏按钮逻辑
  clickMenuButton() {
    animateTo(
      {
        duration: 300, // 动画持续时间（毫秒）
        curve: Curve.EaseInOut, // 动画曲线
      },
      () => {
        this.sideBarWidth = this.sideBarWidth === 58 ? 200 : 58; // 切换宽度值
      }
    )
  }

  build() {
    //界面行
    Stack() {
      // 右侧内容区-----------------------
      Column() {
        // 根据 selectedIndex 渲染不同页面
        if (this.selectedIndex === 0) {
          HomePage();
        } else if (this.selectedIndex === 1) {
          EnvironmentControlPage();
        } else if (this.selectedIndex === 2) {
          DeviceControlPage();
        } else if (this.selectedIndex === 3) {
          EnvironmentSecurityPage();
        } else if (this.selectedIndex === 4) {
          EmployeeAdminPage();
        } else if (this.selectedIndex === 5) {
          SystemControl();
        }
      }
      .margin({ left: 58 })
      .onTouch((event: TouchEvent) => {
        // 如果禁止侧滑展开，且侧边栏当前是收起状态，就什么也不做
        const isSwipeDisabled = this.disableSwipeOpen;
        if (isSwipeDisabled && this.collapsed) {
          // 这里要允许收起时的触发（Up/Cancel）继续走，否则侧边栏可能卡在半开
          if (event.type === TouchType.Down || event.type === TouchType.Move) {
            return;
          }
        }

        const THRESHOLD_PX = 100; // 开始拖拽的最小位移
        if (event.type === TouchType.Down) { // 按下
          this.startX = event.touches[0].x;
          this.startWidth = this.sideBarWidth;
          this.isDragging = false; // 先关闭“拖拽模式”
          return;
        }

        if (event.type === TouchType.Move) { // 移动
          const deltaX = event.touches[0].x - this.startX;

          // 还没进入拖拽，且位移未达阈值 => 直接忽略
          if (!this.isDragging && Math.abs(deltaX) < THRESHOLD_PX) {
            return;
          }

          // 首次越过阈值：重置参考点，避免突变
          if (!this.isDragging) {
            this.isDragging = true;
            this.startX = event.touches[0].x; // 重新计起点
            this.startWidth = this.sideBarWidth; // 重新计宽度
            return; // 本帧不再更新宽度
          }

          // 已经在拖拽：正常计算
          const newWidth = Math.max(
            this.menuMinWidth,
            Math.min(this.menuMaxWidth, this.startWidth + deltaX)
          );
          this.sideBarWidth = newWidth;
          return;
        }

        if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
          this.isDragging = false;

          // 根据 autoCollapseWidth 判定收合 / 展开
          const threshold = this.autoCollapseWidth;
          const expand = this.sideBarWidth > threshold;
          const target = expand ? this.menuMaxWidth : this.menuMinWidth;
          this.collapsed = !expand;

          // 平滑吸附
          animateTo({ duration: 300, curve: Curve.EaseInOut }, () => {
            this.sideBarWidth = target;
          });
        }
      })

      // 界面蒙层区-----------------------
      Row()
        .width('100%')
        .height('100%')
        .backgroundColor('#3C3F41')
        .opacity(0.5 * ((this.sideBarWidth - this.menuMinWidth) / (this.menuMaxWidth - this.menuMinWidth)))
        .hitTestBehavior(HitTestMode.Transparent)
        .onTouchIntercept((event) => {
          if (event.type === TouchType.Down && !this.collapsed) {
            // 处理关闭逻辑
            this.clickMenuButton();
          }
          // 让触摸继续向下分发
          return HitTestMode.Transparent;
        })
      // 导航侧边栏-----------------------
      Column() {
        //APP标志
        RelativeContainer() {
          //APPLogo
          Image($r('app.media.icon_app'))
            .id('iconLogo')
            .width(25)
            .height(25)
            .opacity(Math.max(
              0,
              (this.sideBarWidth - this.menuMinWidth)
                / (this.menuMaxWidth - this.menuMinWidth)
            ))
            .alignRules({
              center: {
                anchor: '__container__',
                align: VerticalAlign.Center
              }
            });
          //APP名称
          Text("智慧工厂")
            .width(150)
            .fontSize(16)
            .fontColor('#ffffff')
            .fontWeight(FontWeight.Bold)
            .margin({ left: 10 })
            .opacity(
              this.sideBarWidth < 150
                ? 0
                : this.sideBarWidth > 200
                ? 1
                : (this.sideBarWidth - 150) / (200 - 150)
            )
            //.visibility(this.collapsed ? Visibility.Hidden : Visibility.Visible)
            .alignRules({
              left: {
                anchor: 'iconLogo',
                align: HorizontalAlign.End
              },
              center: {
                anchor: 'iconLogo',
                align: VerticalAlign.Center
              }
            });
          //菜单按钮
          Button({ type: ButtonType.Normal, stateEffect: true }) {
            Image($r('app.media.icon_menu'))
              .width('60%')
              .height('60%');
          }
          .width('40')
          .height('40')
          .backgroundColor('transparent')
          .borderRadius('15px')
          .alignRules({
            right: {
              anchor: '__container__',
              align: HorizontalAlign.End
            },
            center: {
              anchor: '__container__',
              align: VerticalAlign.Center
            }
          })
          .onClick(() => this.clickMenuButton());
        }
        .width('100%')
        .height(50)
        .padding({ left: 15, right: 10 })
        .backgroundColor('#ff1f2937')

        //菜单列
        Column({ space: 5 }) {
          ForEach(this.tabs, (item: Tab, index: number) => {
            Row({ space: 10 }) {
              Image(item.icon)
                .width(20)
                .height(20)
              Text(item.title)
                .width(150)
                .fontSize(14)
                .fontColor('#ffffff')
                .opacity(Math.max(
                  0,
                  (this.sideBarWidth - this.menuMinWidth)
                    / (this.menuMaxWidth - this.menuMinWidth)
                ))
            }
            .width('100%')
            .height(50)
            .borderRadius('15px')
            .padding(10)
            .padding({ left: 15 })
            .backgroundColor(
              this.hoverIndex === index
                ? '#374151'
                : this.selectedIndex === index
                ? '#1F2937'
                : 'transparent'
            )
            .onClick(() => {
              this.selectedIndex = index;
            })
            .onHover((hovered: boolean) => {
              this.hoverIndex = hovered ? index : -1;
            });
          })
        }
        .alignItems(HorizontalAlign.Start)
        .padding(5)
      }
      .width(this.sideBarWidth)
      .height('100%')
      .backgroundColor('#111827')
      .clip(true)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFD86B')
    .align(Alignment.Start)
  }
}


// 无阈值的拖拽处理
// .onTouch((event: TouchEvent) => {
//   if (event.type === TouchType.Down) {
//     this.isDragging = true;
//     this.startX = event.touches[0].x;
//     this.startWidth = this.sideBarWidth;
//   } else if (event.type === TouchType.Move && this.isDragging) {
//     const currentX = event.touches[0].x;
//     const deltaX = currentX - this.startX;
//     let newWidth = 0;
//     newWidth = this.startWidth + deltaX;
//     newWidth = Math.max(this.menuMinWidth, Math.min(this.menuMaxWidth, newWidth));
//     this.sideBarWidth = newWidth;
//   } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
//     this.isDragging = false;
//     const threshold = this.autoCollapseWidth
//     if (this.sideBarWidth > threshold) {
//       this.sideBarWidth = this.menuMaxWidth;
//       this.collapsed = true;
//       animateTo(
//         {
//           duration: 300,
//           curve: Curve.EaseInOut,
//         },
//         () => {
//           this.sideBarWidth = 200;
//         }
//       )
//       console.log("展开了")
//     } else if (this.sideBarWidth < threshold) {
//       this.sideBarWidth = this.menuMinWidth;
//       this.collapsed = false;
//       animateTo(
//         {
//           duration: 300, // 动画持续时间（毫秒）
//           curve: Curve.EaseInOut, // 动画曲线
//         },
//         () => {
//           this.sideBarWidth = 58; // 切换宽度值
//         }
//       )
//       console.log("关闭了")
//     }
//   }
// })