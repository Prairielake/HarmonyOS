import router from '@ohos.router'

@Component
export default struct GoodItem {
  @State goodId: number = 0
  @State img: string = ''
  @State desc: string = ''
  @State price: number = 0
  @State count: string = ''

  build() {
    Column() {
      //商品图片
      Image(this.img)
        .width('100%')
        .height(165)
        .borderRadius(10)

      //商品描述
      Text(this.desc)
        .fontSize(14)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Clip })
        .padding(3)
        .margin({ top: 10, left: 3, right: 3 })


      //商品价格和销量
      Row() {
        Text('￥')
          .fontSize(14)
          .fontColor($r('app.color.global_color'))
          .padding({ top: 2 })

        Text(this.price.toString())
          .fontSize(18)
          .fontColor($r('app.color.global_color'))

        Text(this.count + '+人已购买')
          .fontSize(12)
          .fontColor(Color.Gray)
          .padding({ top: 3 })
          .margin({ left: 5 })
      }
      .width('100%')
      .padding(3)
      .margin({ left: 3, right: 3 })

    }
    .width('49%')
    .height(250)
    .borderRadius(10)
    .backgroundColor('#FFF')
    .margin({ top: 5, bottom: 5 })
    .onClick(() => {
      router.pushUrl({ url: 'pages/Detail', params: { goodId: this.goodId } })
    })

  }
}