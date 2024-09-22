import serviceDialogText from '../data/dialog/serviceDialogText'
import privacyDialogText from '../data/dialog/privacyDialogText'
import lawDialogText from '../data/dialog/lawDialogText'
import userList, { UserItemType } from '../data/userList'
import router from '@ohos.router'

interface RouterParamsType {
  index: number
}

@Entry
@Component
struct Login {
  //表单类型
  @State formType: boolean = true
  //接受验证码页面
  @State isCode: boolean = false
  //聚焦
  @State phoneFocus: boolean = false
  @State acceptFocus: boolean = false
  @State passwordFocus: boolean = false
  @State codesFocus: boolean[] = [false, false, false, false]
  //获取验证码文本
  @State codeText: string = '重新获取验证码'
  //获取验证码可用
  @State codeFlag: boolean = true
  //倒计时可开始
  @State countdown: boolean = true
  //最大倒计时
  private maxCount: number = 10
  //倒计时数字
  @State count: number = this.maxCount
  //计时器返回值
  @State timer: number = 0
  //输入
  @State phone: string = ''
  @State accept: string = ''
  @State password: string = ''
  @State codes: string[] = ['', '', '', '']
  //同意
  @State isAgree: boolean = false
  //登陆中
  @State isLogin: boolean = false
  //登陆后目标索引
  private index: number = 0
  //手机格式错误弹窗控制器
  private phoneErrorDialogController: CustomDialogController = new CustomDialogController({
    builder: ErrorDialog({ errorMessage: '手机号码格式不正确, 请重新输入' })
  })
  //账密错误弹窗控制器
  private acceptPwdErrorDialogController: CustomDialogController = new CustomDialogController({
    builder: ErrorDialog({ errorMessage: '账密错误' })
  })
  //协议同意弹窗控制器
  private agreeDialogController: CustomDialogController = new CustomDialogController({
    builder: AgreeDialog({
      confirm: (flag: boolean) => {
        this.isAgree = flag
        if (this.isAgree) {
          this.login()
        }
      }
    })
  })
  //协议弹窗控制器
  private serviceDialogController: CustomDialogController = new CustomDialogController({
    builder: ServiceDialog()
  })
  private privacyDialogController: CustomDialogController = new CustomDialogController({
    builder: PrivacyDialog()
  })
  private lawDialogController: CustomDialogController = new CustomDialogController({
    builder: LawDialog()
  })

  //赋值处理器
  changeHandler(type: string, val: string) {
    if (type === 'phone') {
      this.phone = val
    } else if (type === 'accept') {
      this.accept = val
    } else if (type === 'password') {
      this.password = val
    }
  }

  //登录操作
  login() {
    this.isLogin = true
    setTimeout(() => {
      this.loginHandler()
      this.isLogin = false
    }, 1000)
  }

  //登录处理器
  loginHandler() {
    //手机验证码登录
    if (this.formType) {
      //验证手机号格式
      if (!/^\d{11}$/.test(this.phone)) {
        this.phoneErrorDialogController.open()
        return
      }
      this.isCode = true
      this.codeHandler()
      return
    }
    //账号密码登录
    else {
      const userInfo: UserItemType | undefined =
        userList.find(item => item.accept === this.accept && item.password === this.password)
      if (userInfo === undefined) {
        this.acceptPwdErrorDialogController.open()
        return
      }
      AppStorage.setOrCreate('user', userInfo)
    }
    router.replaceUrl({ url: 'pages/TabIndex', params: { index: this.index } })
  }

  //验证码处理器
  codeHandler() {
    if (!this.codeFlag) {
      return
    }
    this.codeFlag = false
    this.codeText = `再次获取(${this.count}s)`

    this.countdown = false
    this.timer = setInterval(() => {
      this.count--
      this.codeText = `再次获取(${this.count}s)`
      if (this.count <= 0) {
        clearInterval(this.timer)
        this.codeText = '重新获取验证码'
        this.countdown = true
        this.codeFlag = true
        this.count = this.maxCount
      }
    }, 1000)
  }

  aboutToAppear(): void {
    const routerParams: RouterParamsType = router.getParams() as RouterParamsType
    this.index = routerParams.index
  }

  build() {
    //接收验证码页面
    if (this.isCode) {
      Column() {
        Row() {
          Text('验证码将发送到')
            .fontSize(22)
            .fontWeight(400)
            .fontColor(Color.Gray)

          Text(this.phone)
            .fontSize(22)
            .fontWeight(400)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ left: 10, right: 10 })
        .margin({ top: 50 })


        Row() {
          ForEach([0, 1, 2, 3], (index: number) => {
            TextInput()
              .width(60)
              .height(65)
              .fontSize(40)
              .fontWeight(600)
              .textAlign(TextAlign.Center)
              .backgroundColor(this.codesFocus[index] ? '#FFF' : '#F3F3F3')
              .borderWidth(1)
              .borderColor(this.codesFocus[index] ? $r('app.color.global_color') : Color.Transparent)
              .borderRadius(10)
              .maxLength(1)
              .type(InputType.Number)
              .onFocus(() => {
                this.codesFocus[index] = true
              })
              .onBlur(() => {
                this.codesFocus[index] = false
              })
              .onChange((val: string) => {
                this.codes[index] = val
                let loginFlag = true
                this.codes.forEach((item: string) => {
                  if (item === '') {
                    loginFlag = false
                  }
                })
                if (loginFlag) {
                  AppStorage.setOrCreate('user', {
                    "id": 0,
                    "nickname": `${this.phone}`,
                    "accept": `tb${this.phone}`,
                    "password": "123",
                    "avatar": "https://gw.alicdn.com/sns_logo/TB1e4rMt8Bh1e4jSZFhXXcC9VXa-240-240.png_120x120.jpg_.webp"
                  })
                  router.replaceUrl({ url: 'pages/TabIndex', params: { index: this.index } })
                }
              })
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ left: 10, right: 10 })
        .margin({ top: 20 })


        //获取验证码可用
        if (this.codeFlag) {
          Text(this.codeText)
            .width(200)
            .height(40)
            .fontSize(22)
            .fontWeight(400)
            .fontColor($r('app.color.global_color'))
            .textAlign(TextAlign.Center)
            .backgroundColor('#FFF')
            .borderWidth(2)
            .borderColor($r('app.color.global_color'))
            .borderRadius(20)
            .margin({ top: 80 })
            .onClick(() => {
              this.codeHandler()
            })
        }
        //等待验证码
        else {
          Column() {
            Row() {
              Text('验证码已发送')
                .fontSize(18)
                .fontColor(Color.Gray)
              Text(`(${this.count}s)`)
                .fontSize(18)
                .fontColor(Color.Gray)
            }

            Text('可能会有延后请耐心等待...')
              .fontSize(18)
              .fontColor(Color.Gray)
              .padding({ top: 3 })
          }
          .height(40)
          .margin({ top: 80 })
        }

        Text('账号密码登录')
          .fontSize(20)
          .fontWeight(400)
          .fontColor($r('app.color.global_color'))
          .margin({ top: 30 })
          .onClick(() => {
            this.phone = ''
            this.formType = false
            this.isCode = false
          })
      }
      .width('90%')
      .height('100%')
      .margin({ left: '5%', right: '5%' })

    }
    //登录页面
    else {
      Column() {
        //顶部提示
        Row() {
          Text('您需要登录才能继续访问')
            .fontSize(18)
            .fontWeight(600)
            .margin({ left: 20, right: 20 })

          Text('关闭')
            .fontSize(18)
            .fontWeight(600)
            .fontColor('#999999')
            .margin({ left: 20, right: 20 })
            .onClick(() => {
              router.back()
            })
        }
        .width('100%')
        .height(60)
        .backgroundColor('#EEEEEE')
        .justifyContent(FlexAlign.SpaceBetween)

        Image($rawfile('img/login/icon.png'))
          .width(80)

        //手机号验证码表单
        if (this.formType) {
          //手机号
          Row() {
            Text('+86')
              .fontSize(16)
              .margin({ left: 15 })

            Image('https://gw.alicdn.com/tfs/TB1.8ugw.T1gK0jSZFrXXcNCXXa-200-200.png')
              .width(25)

            TextInput({ placeholder: '请输入手机号', text: this.phone })
              .placeholderFont({ size: 18 })
              .fontSize(18)
              .backgroundColor(Color.Transparent)
              .onFocus(() => {
                this.phoneFocus = true
              })
              .onBlur(() => {
                this.phoneFocus = false
              })
              .onChange((val: string) => {
                this.changeHandler('phone', val)
              })
          }
          .width('80%')
          .height(60)
          .backgroundColor(this.phoneFocus ? Color.Transparent : '#EEE')
          .borderWidth(2)
          .borderColor(this.phoneFocus ? $r('app.color.global_color') : Color.Transparent)
          .borderRadius(15)
          .margin({ left: '10%', right: '10%', top: 24 })
        }
        //账号密码表单
        else {
          //账号
          TextInput({ placeholder: '手机号/邮箱/账号名' })
            .width('80%')
            .height(60)
            .placeholderFont({ size: 18 })
            .fontSize(18)
            .backgroundColor(this.acceptFocus ? Color.Transparent : '#EEE')
            .borderWidth(2)
            .borderColor(this.acceptFocus ? $r('app.color.global_color') : Color.Transparent)
            .borderRadius(15)
            .margin({ left: '10%', right: '10%', top: 24 })
            .onFocus(() => {
              this.acceptFocus = true
            })
            .onBlur(() => {
              this.acceptFocus = false
            })
            .onChange((val: string) => {
              this.changeHandler('accept', val)
            })

          //密码
          TextInput({ placeholder: '请输入登录密码' })
            .width('80%')
            .height(60)
            .placeholderFont({ size: 18 })
            .fontSize(18)
            .backgroundColor(this.passwordFocus ? Color.Transparent : '#EEE')
            .borderWidth(2)
            .borderColor(this.passwordFocus ? $r('app.color.global_color') : Color.Transparent)
            .borderRadius(15)
            .margin({ left: '10%', right: '10%', top: 24 })
            .type(InputType.Password)
            .onFocus(() => {
              this.passwordFocus = true
            })
            .onBlur(() => {
              this.passwordFocus = false
            })
            .onChange((val: string) => {
              this.changeHandler('password', val)
            })
        }

        Text(this.isLogin ? '登录中...' : '登录')
          .width('80%')
          .height(50)
          .fontSize(20)
          .fontWeight(600)
          .fontColor('#FFF')
          .textAlign(TextAlign.Center)
          .borderRadius(20)
          .margin({ top: 24 })
          .linearGradient({
            direction: GradientDirection.Left,
            colors: [[0xFF5000, 0], [0xFF8400, 1]]
          })
          .onClick(() => {
            if (this.isLogin) {
              return
            }
            if (!this.isAgree) {
              this.agreeDialogController.open()
              return
            }
            this.login()
          })

        Text(this.formType ? '账号密码登录' : '短信验证码登录')
          .fontSize(18)
          .margin(24)
          .onClick(() => {
            this.formType = !this.formType
          })


        //用户协议
        Row() {
          //复选框
          Checkbox()
            .width(20)
            .select(this.isAgree)
            .selectedColor($r('app.color.global_color'))
            .onChange((flag: boolean) => {
              this.isAgree = flag
            })
            .padding({ bottom: 12 })

          Column() {
            Row() {
              Text('已阅读并同意以下协议')
                .fontSize(14)
                .fontColor(Color.Gray)

              Text('《淘宝平台服务协议》')
                .fontSize(14)
                .onClick(() => {
                  this.serviceDialogController.open()
                })
            }

            Row() {
              Text('《隐私权政策》')
                .fontSize(14)
                .onClick(() => {
                  this.privacyDialogController.open()
                })

              Text('《法律声明》')
                .fontSize(14)
                .onClick(() => {
                  this.lawDialogController.open()
                })
            }
          }
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .height(100)
        .position({ x: '5%', y: '75%' })

      }
    }
  }
}

@CustomDialog
struct ErrorDialog {
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: this
  })
  private errorMessage: string = 'ErrorMessage'

  build() {
    Column() {
      Row() {
        Text(this.errorMessage)
          .fontSize(18)
          .fontColor(Color.Gray)
      }
      .width('100%')
      .height(65)
      .justifyContent(FlexAlign.Center)

      Divider()
        .width('100%')

      Text('确认')
        .fontSize(18)
        .fontColor($r('app.color.global_color'))
        .margin({ top: 20 })
        .onClick(() => {
          this.dialogController.close()
        })
    }
    .width('100%')
    .height(120)
    .backgroundColor('#FFF')

  }
}

//同意协议弹窗
@CustomDialog
struct AgreeDialog {
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: this
  })
  confirm: (flag: boolean) => void = () => {
  }

  build() {
    Column() {
      Row() {
        Text('服务协议及隐私保护')
          .fontSize(18)
      }

      Column() {
        Row() {
          Text('为了更好地保护您的合法权益, 请您阅读')
            .fontColor(Color.Gray)
        }
        .width('95%')

        Row() {
          Text('并同意以下协议')
            .fontColor(Color.Gray)
          Text('《淘宝平台服务协议》')
        }
        .width('95%')

        Row() {
          Text('《隐私权政策》')

          Text('《法律声明》')

        }
        .width('95%')
      }
      .width('100%')
      .height(70)

      Row() {
        Text('不同意')
          .width(130)
          .height(40)
          .textAlign(TextAlign.Center)
          .fontSize(18)
          .fontWeight(400)
          .fontColor($r('app.color.global_color'))
          .borderRadius(20)
          .borderWidth(1)
          .borderColor($r('app.color.global_color'))
          .onClick(() => {
            this.confirm(false)
            this.dialogController.close()
          })

        Text('同意')
          .width(130)
          .height(40)
          .textAlign(TextAlign.Center)
          .fontSize(18)
          .fontWeight(400)
          .fontColor('#FFF')
          .borderRadius(20)
          .linearGradient({
            direction: GradientDirection.Left,
            colors: [[0xFF5000, 0], [0xFF8400, 1]]
          })
          .onClick(() => {
            this.confirm(true)
            this.dialogController.close()
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .width('90%')
    .height(250)
    .backgroundColor('#FFF')
    .justifyContent(FlexAlign.SpaceEvenly)
  }
}

//服务弹窗
@CustomDialog
struct ServiceDialog {
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: this
  })

  build() {
    Scroll() {
      Column() {
        Text(serviceDialogText)
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
  }
}

//隐私弹窗
@CustomDialog
struct PrivacyDialog {
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: this
  })

  build() {
    Scroll() {
      Column() {
        Text(privacyDialogText)
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
  }
}

//法律弹窗
@CustomDialog
struct LawDialog {
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: this
  })

  build() {
    Scroll() {
      Column() {
        Text(lawDialogText)
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
  }
}