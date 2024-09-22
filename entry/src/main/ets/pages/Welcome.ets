import router from '@ohos.router'

@Entry
@Component
struct Welcome {
  @State countdown: number = 5
  @State timer: number = 0

  aboutToAppear(): void {
    this.timer = setInterval(() => {
      this.countdown--
      if (this.countdown <= 0) {
        clearInterval(this.timer)
        router.replaceUrl({ url: 'pages/TabIndex' })
      }
    }, 1000)
  }

  build() {
    Column() {
      Text('欢迎')
        .fontSize(50)
        .fontWeight(600)
        .fontColor($r('app.color.global_color'))

      Image($rawfile('img/welcome/welcome.jpg'))
        .width('100%')

      Stack() {
        Circle({ width: 30, height: 30 })
          .fill('#333')
          .fillOpacity(0.5)

        Text(this.countdown.toString())
          .fontWeight(600)
          .fontColor('#FFF')
      }.position({ x: '90%', y: 10 })

      Text('立即进入')
        .fontSize(18)
        .padding({
          top: 10,
          bottom: 10,
          left: 20,
          right: 20
        })
        .backgroundColor('#33333377')
        .borderRadius(30)
        .fontColor('#FFF')
        .onClick(() => {
          clearInterval(this.timer)
          router.replaceUrl({ url: 'pages/TabIndex' })
        })
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.SpaceEvenly)
    .backgroundColor('#FFF')
    .padding({ left: 10, right: 10 })
  }
}

