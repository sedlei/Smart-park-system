interface TabData {
  title: string
}

interface EmployeeData {
  name: string
  id: string
  idCard: string
}

@ComponentV2
export struct AddEmployeePage {
  @Local employeeName: string = ''
  @Local employeeId: string = ''
  @Local employeeIdCard: string = ''

  build() {
    Column() {
      Column({ space: 10 }) {
        // 标题文本
        Text('添加新员工')
          .width('100%')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)

        // 姓名输入区
        Column() {
          Text('员工姓名')
            .width('100%')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
          TextInput()
            .width('100%')
            .height(30)
            .border({ width: 1, color: '#E0E0E0', radius: 5 })
            .onChange((value: string) => {
              this.employeeName = value
            })
        }
        .width('100%')

        // 工号输入区
        Column() {
          Text('工号')
            .width('100%')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
          TextInput()
            .width('100%')
            .height(30)
            .border({ width: 1, color: '#E0E0E0', radius: 5})
            .onChange((value: string) => {
              this.employeeId = value
            })
        }
        .width('100%')

        // 身份证号输入区
        Column() {
          Text('身份证号')
            .width('100%')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
          TextInput()
            .width('100%')
            .height(30)
            .border({ width: 1, color: '#E0E0E0', radius: 5 })
            .onChange((value: string) => {
              this.employeeIdCard = value
            })
        }
        .width('100%')

        Blank();

        // 操作按钮
        Button('添加员工')
          .width('100%')
          .height(35)
          .backgroundColor('#0f172a')
          .borderRadius(8)
          .onClick(() => {
            if (this.employeeName && this.employeeId && this.employeeIdCard) {
              AlertDialog.show({
                title: '成功',
                message: '员工添加成功',
                confirm: {
                  value: '确定',
                  action: () => {
                    // 清空输入
                    this.employeeName = ''
                    this.employeeId = ''
                    this.employeeIdCard = ''
                  }
                }
              })
            } else {
              AlertDialog.show({
                title: '错误',
                message: '请填写所有必填信息',
                confirm: {
                  value: '确定',
                  action: () => {
                  }
                }
              })
            }
          })
      }
      .width('60%')
      .height('100%')
      .padding(20)
      .borderRadius(8)
      .backgroundColor('#FFFFFF')
      .shadow({ radius: 6, color: '#1F000000', offsetX: 2, offsetY: 4 })
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#F3F4F6')
  }
}