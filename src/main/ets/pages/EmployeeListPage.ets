interface TabData {
  title: string
}

interface EmployeeData {
  name: string
  id: string
  status: string
  lastLoginTime: string
}

@ComponentV2
export struct EmployeeListPage {
  @Local searchText: string = ''
  @Local employees: EmployeeData[] = [
    { name: '张三', id: 'EMP001', status: '正常', lastLoginTime: '2024-01-15 08:30:00' },
    { name: '李四', id: 'EMP002', status: '正常', lastLoginTime: '2024-01-15 09:15:00' },
    { name: '王五', id: 'EMP003', status: '锁定', lastLoginTime: '2024-01-10 17:45:00' }
  ]
  @Local filteredEmployees: EmployeeData[] = []
  @Local currentTabIndex: number = 1
  private tabsData: TabData[] = [
    { title: '统计信息' },
    { title: '员工列表' },
    { title: '添加员工' }
  ]

  aboutToAppear() {
    this.filterEmployees()
  }

  // 搜索处理
  filterEmployees() {
    if (this.searchText.trim() === '') {
      // 使用数组的slice()方法代替展开运算符
      this.filteredEmployees = this.employees.slice()
    } else {
      this.filteredEmployees = this.employees.filter(emp =>
      emp.name.includes(this.searchText) || emp.id.includes(this.searchText)
      )
    }
  }

  // 更新员工状态
  updateEmployeeStatus(employeeId: string, isNormal: boolean) {
    this.employees = this.employees.map(emp => {
      if (emp.id === employeeId) {
        // 创建新对象而不使用展开运算符
        return {
          name: emp.name,
          id: emp.id,
          lastLoginTime: emp.lastLoginTime,
          status: isNormal ? '正常' : '锁定'
        }
      }
      return emp
    })
    this.filterEmployees()
  }

  // 删除员工
  deleteEmployee(employeeId: string) {
    AlertDialog.show({
      title: '确认删除',
      message: '确定要删除该员工吗？此操作不可恢复。',
      primaryButton: {
        value: '取消',
        action: () => {
          console.info('取消删除')
        }
      },
      secondaryButton: {
        value: '删除',
        action: () => {
          this.employees = this.employees.filter(emp => emp.id !== employeeId)
          this.filterEmployees()
        }
      }
    })
  }

  build() {
    Column() {
      // 搜索框
      Row() {
        Search({ value: this.searchText, placeholder: '搜索员工姓名或工号...' })
          .width('100%')
          .height(40)
          .backgroundColor('#FFFFFF')
          .border({ width: 1, color: "#E3E9F0", radius: 8 })
          .onChange((value: string) => {
            this.searchText = value
            this.filterEmployees()
          })
      }
      .width('100%')
      .height('15%')

      // 员工列表区
      Column() {
        // 表头
        Row() {
          Text('姓名')
            .width('20%')
            .textAlign(TextAlign.Center)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
          Text('工号')
            .width('20%')
            .textAlign(TextAlign.Center)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
          Text('状态')
            .width('20%')
            .textAlign(TextAlign.Center)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
          Text('最后进入')
            .width('25%')
            .textAlign(TextAlign.Center)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
          Text('操作')
            .width('15%')
            .textAlign(TextAlign.Center)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .padding(10)

        // 员工列表
        List() {
          ForEach(this.filteredEmployees, (employee: EmployeeData) => {
            ListItem() {
              Row() {
                Text(employee.name)
                  .width('20%')
                  .textAlign(TextAlign.Center)
                  .fontSize(14)
                Text(employee.id)
                  .width('20%')
                  .textAlign(TextAlign.Center)
                  .fontSize(14)
                Text(employee.status)
                  .width('20%')
                  .textAlign(TextAlign.Center)
                  .fontColor(employee.status === '正常' ? '#2196F3' : '#FF0000')
                  .fontSize(14)
                Text(employee.lastLoginTime)
                  .width('25%')
                  .textAlign(TextAlign.Center)
                  .fontSize(14)
                Row() {
                  Toggle({ type: ToggleType.Switch, isOn: employee.status === '正常' })
                    .onChange((isOn: boolean) => {
                      this.updateEmployeeStatus(employee.id, isOn)
                    })
                    .margin({ right: 8 })
                  Button({ type: ButtonType.Circle }) {
                    Image($r('app.media.icon_door_open'))
                      .width(20)
                      .height(20)
                  }
                  .width(32)
                  .height(32)
                  .backgroundColor('#FF0000')
                  .onClick(() => {
                    this.deleteEmployee(employee.id)
                  })
                }
                .width('15%')
                .justifyContent(FlexAlign.Center)
              }
              .width('100%')
              .padding(10)
              .backgroundColor('#FFFFFF')
              .border({
                width: { top: 1, bottom: 0, left: 0, right: 0 },
                color: '#E5EAF1',
                //radius: 8
              })
            }
          })
        }
        .width('100%')
        .layoutWeight(1)
        .margin({ top: 8 })
      }
      .width('100%')
      .height('85%')
      .padding(10)
      .borderRadius(8)
      .backgroundColor('#FFFFFF')
      .shadow({ radius: 6, color: '#1F000000', offsetX: 2, offsetY: 4 })
    }
    .width('100%')
    .height('100%')
    .padding({ top: 10, right: 20, bottom: 20, left: 20 })
    .backgroundColor('#F5F5F5')
  }
}