import GoodItem from '../components/GoodItem'
import { CartItemType } from '../data/cartList'
import { CollectItemType } from '../data/collectList'
import { GoodItemType } from '../data/goodList'
import router from '@ohos.router'

@Component
export default struct TabCart {
  //购物列表
  @StorageLink('cart') cartList: CartItemType[] = []
  //商品列表
  @StorageLink('goods') goodList: GoodItemType[] = []
  //收藏列表
  @StorageLink('collect') collectList: CollectItemType[] = []
  //总数
  @State totalNum: number = 0
  //总价
  @State totalPrice: number = 0
  //删除模式
  @State isDelete: boolean = false
  //置顶键显示
  @State goTopFlag: boolean = false
  //全选
  @State selectAll: boolean = false
  private scroller: Scroller = new Scroller()

  //左滑删除模块
  @Builder
  CartItemDelete(index: number) {
    Column() {
      Image($rawfile('img/cart/delete.png'))
        .width(60)

      Text('删除')
        .fontSize(18)
        .fontWeight(600)
        .fontColor('#FFF')
        .margin({ top: 10 })
    }
    .width(80)
    .height('100%')
    .backgroundColor(Color.Red)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.cartList.splice(index, 1)
      this.calculateHandler()
    })
  }

  //右滑收藏模块
  @Builder
  CartItemEdit(index: number) {
    Column() {
      Image($rawfile('img/cart/shop.png'))
        .width(60)

      Text('收藏')
        .fontSize(18)
        .fontWeight(600)
        .fontColor('#FFF')
        .margin({ top: 10 })
    }
    .width(80)
    .height('100%')
    .backgroundColor($r('app.color.global_color'))
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.collectList.push({
        id: this.cartList[index].id,
        img: this.cartList[index].img,
        desc: this.cartList[index].desc,
        price: this.cartList[index].price,
        count: this.cartList[index].count,
        isSelect: this.cartList[index].isSelect
      })
    })
  }

  calculateHandler() {
    let num: number = 0
    let price: number = 0
    this.cartList.forEach((item: CartItemType) => {
      if (item.isSelect) {
        num++
        price += item.price * item.buyNum
      }
    })
    this.totalNum = num
    this.totalPrice = price
    this.selectAll = this.totalNum === this.cartList.length
  }

  //Test
  test() {
    AppStorage.setOrCreate('cart', [
      {
        id: 1,
        img: 'https://gw.alicdn.com/bao/uploaded/i3/801836345/O1CN01yFleMf1wk3zmxBejU_!!0-item_pic.jpg_320x320q90.jpg_.webp',
        desc: '藏生堂藏奥堂川圣堂藏御堂香柏木足浴泡脚木桶家用木质高深桶熏蒸',
        price: 136,
        count: '200',
        buyNum: 1,
        isSelect: true
      },
      {
        id: 2,
        img: 'https://gw.alicdn.com/bao/uploaded/i3/6000000002164/O1CN01KNnzJa1RrA3Wvf4yj_!!6000000002164-0-sm.jpg_320x320q90.jpg_.webp',
        desc: '蒂安黑胡椒粒现磨意大利进口研磨瓶46g烧烤牛排意面健身',
        price: 32.8,
        count: '500',
        buyNum: 1,
        isSelect: false
      },
      {
        id: 3,
        img: 'https://gw.alicdn.com/bao/uploaded/i1/924188673/O1CN015pzi0E2DwHw3GT0z6_!!924188673.jpg_320x320q90.jpg_.webp',
        desc: '美国通用磨坊cheerios原味蜂蜜燕五谷麦圈甜麦圈即食冲饮谷物早餐',
        price: 54.44,
        count: '200',
        buyNum: 1,
        isSelect: false
      }
    ])
  }

  aboutToAppear(): void {
    //this.test()
    this.calculateHandler()
  }

  build() {
    Column() {
      Scroll(this.scroller) {
        Column() {
          //Empty
          if (this.cartList.length === 0) {
            Column() {
              //统计
              Row() {
                Text(`购物车(0)`)
                  .fontSize(24)
                  .fontWeight(600)
                  .fontColor('#FFF')
                  .position({ x: 15, y: 20 })
              }
              .width('100%')
              .height(100)
              .linearGradient({
                direction: GradientDirection.Left,
                colors: [[0xFF5000, 0], [0xFF8400, 1]]
              })


              Image('https://gw.alicdn.com/tfs/TB1U0RydwoQMeJjy1XaXXcSsFXa-220-220.png_190x190q90_.webp')
                .width(80)
                .margin({ top: 10 })

              Text('购物车竟然是空的')
                .margin({ top: 10 })
            }
          }
          //Not Empty
          else {
            //统计
            Column() {
              Row() {
                Column() {
                  Text(`购物车(${this.cartList.length})`)
                    .fontSize(24)
                    .fontWeight(600)
                    .fontColor('#FFF')

                  Text(`共${this.cartList.length}件宝贝`)
                    .fontSize(14)
                    .fontColor('#FFF')
                    .padding({ right: 30 })
                    .margin({ top: 15 })
                }

                Text(this.isDelete ? '完成' : '管理')
                  .fontSize(18)
                  .fontWeight(600)
                  .fontColor('#FFF')
                  .padding({ bottom: 30 })
                  .onClick(() => {
                    this.isDelete = !this.isDelete
                  })
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({ left: 15, right: 15 })
              .margin({ top: 20 })

              Row()
                .width('100%')
                .height(100)
                .position({ x: 0, y: 100 })
                .linearGradient({
                  direction: GradientDirection.Left,
                  colors: [[0xFF5000, 0], [0xFF8400, 1]]
                })
            }
            .width('100%')
            .height(100)
            .linearGradient({
              direction: GradientDirection.Left,
              colors: [[0xFF5000, 0], [0xFF8400, 1]]
            })

            //购物列表
            List() {
              ForEach(this.cartList, (item: CartItemType, index: number) => {
                ListItem() {
                  //单件商品
                  Row() {
                    //复选框
                    Checkbox()
                      .width(25)
                      .margin({ left: 10, right: 10 })
                      .selectedColor($r('app.color.global_color'))
                      .select(item.isSelect)
                      .onClick(() => {
                        this.cartList[index] = {
                          id: item.id,
                          img: item.img,
                          desc: item.desc,
                          count: item.count,
                          price: item.price,
                          buyNum: item.buyNum,
                          isSelect: !item.isSelect
                        }
                        this.calculateHandler()
                      })

                    //商品图片
                    Image(item.img)
                      .width(115)
                      .borderRadius(5)

                    //商品信息
                    Column() {
                      //商品描述
                      Text(item.desc)
                        .fontSize(16)
                        .fontWeight(600)
                        .maxLines(2)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                        .padding({ bottom: 57 })

                      Row() {
                        //商品价格
                        Text(`￥${item.price}`)
                          .fontSize(16)
                          .fontColor($r('app.color.global_color'))

                        //计数器
                        Row() {
                          Text('-')
                            .width(24)
                            .height(24)
                            .fontSize(16)
                            .textAlign(TextAlign.Center)
                            .borderWidth(1)
                            .borderColor('#CCC')
                            .onClick(() => {
                              if (item.buyNum <= 1) {
                                return
                              }
                              this.cartList[index] = {
                                id: item.id,
                                img: item.img,
                                desc: item.desc,
                                price: item.price,
                                count: item.count,
                                buyNum: item.buyNum - 1,
                                isSelect: item.isSelect
                              }
                              this.calculateHandler()
                            })
                          Text(item.buyNum.toString())
                            .width(40)
                            .height(24)
                            .fontSize(16)
                            .textAlign(TextAlign.Center)
                            .borderWidth(1)
                            .borderColor('#CCC')
                          Text('+')
                            .width(24)
                            .height(24)
                            .fontSize(16)
                            .textAlign(TextAlign.Center)
                            .borderWidth(1)
                            .borderColor('#CCC')
                            .onClick(() => {
                              if (item.buyNum >= 99) {
                                return
                              }
                              this.cartList[index] = {
                                id: item.id,
                                img: item.img,
                                desc: item.desc,
                                price: item.price,
                                count: item.count,
                                buyNum: item.buyNum + 1,
                                isSelect: item.isSelect
                              }
                              this.calculateHandler()
                            })
                        }
                      }
                      .width('100%')
                      .justifyContent(FlexAlign.SpaceBetween)

                    }
                    .layoutWeight(1)
                    .padding({ left: 5, right: 5 })
                  }
                  .width('100%')
                  .height(160)
                  .borderRadius(15)
                  .backgroundColor('#FFF')
                  .margin({ top: 5, bottom: 5 })
                  .onClick(() => {
                    router.pushUrl({ url: 'pages/Detail', params: { goodId: item.id } })
                  })
                }
                .width('100%')
                .swipeAction({
                  start: {
                    builder: this.CartItemEdit(index)
                  },
                  end: {
                    builder: this.CartItemDelete(index)
                  }
                })
              })
            }
            .width('94%')
            .zIndex(9999)
          }
          //你可能还喜欢
          Image($rawfile('img/cart/like.png'))
            .width(200)
            .margin({
              left: 10,
              right: 10,
              bottom: 20,
              top: 30
            })

          //推荐列表
          Flex({ justifyContent: FlexAlign.SpaceBetween, wrap: FlexWrap.Wrap }) {
            ForEach(this.goodList, (item: GoodItemType) => {
              GoodItem({
                goodId: item.id,
                img: item.img,
                desc: item.desc,
                price: item.price,
                count: item.count
              })
            })
          }
          .width('100%')
          .margin({ top: 10 })
          .padding({ left: 10, right: 10 })

        }
      }
      .width('100%')
      .height('100%')
      .scrollBarWidth(0)
      .onWillScroll(() => {
        const y = this.scroller.currentOffset().yOffset
        if (y > 400) {
          this.goTopFlag = true
        } else {
          this.goTopFlag = false
        }
      })

      //置顶键
      if (this.goTopFlag) {
        Image('data:image/png;base64,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')
          .width(35)
          .position({ x: '85%', y: '85%' })
          .onClick(() => {
            this.scroller.scrollTo({ xOffset: 0, yOffset: 0 })
            this.goTopFlag = false
          })
      }

      //购物车不为空时出现
      if (this.cartList.length !== 0) {
        //底部统计栏
        Column() {
          Row() {
            //全选
            Row() {
              Checkbox()
                .select(this.selectAll)
                .selectedColor($r('app.color.global_color'))
                .onClick(() => {
                  this.selectAll = !this.selectAll
                  this.cartList.forEach((item: CartItemType, index: number) => {
                    this.cartList[index] = {
                      id: item.id,
                      img: item.img,
                      desc: item.desc,
                      price: item.price,
                      count: item.count,
                      buyNum: item.buyNum,
                      isSelect: this.selectAll
                    }
                  })
                  this.calculateHandler()
                })

              Text('全选')
            }


            if (this.isDelete) {
              Row() {
                //收藏
                Text('移入收藏夹')
                  .width(120)
                  .height(30)
                  .fontSize(18)
                  .fontColor($r('app.color.global_color'))
                  .textAlign(TextAlign.Center)
                  .borderWidth(1)
                  .borderColor($r('app.color.global_color'))
                  .borderRadius(15)
                  .margin({ right: 10 })
                  .onClick(() => {
                    this.cartList.forEach((item: CartItemType, index: number) => {
                      if (item.isSelect) {
                        this.collectList.push({
                          id: this.cartList[index].id,
                          img: this.cartList[index].img,
                          desc: this.cartList[index].desc,
                          price: this.cartList[index].price,
                          count: this.cartList[index].count,
                          isSelect: this.cartList[index].isSelect
                        })
                      }
                    })
                    this.isDelete = false
                  })

                //删除
                Text('删除')
                  .width(70)
                  .height(30)
                  .fontSize(18)
                  .fontColor($r('app.color.global_color'))
                  .textAlign(TextAlign.Center)
                  .borderWidth(1)
                  .borderColor($r('app.color.global_color'))
                  .borderRadius(15)
                  .onClick(() => {
                    for (let i = this.cartList.length - 1; i >= 0; i--) {
                      if (this.cartList[i].isSelect) {
                        this.cartList.splice(i, 1)
                      }
                    }
                    this.isDelete = false
                    this.calculateHandler()
                  })
              }
            } else {
              Row() {
                Text('合计:')

                Text(`￥${this.totalPrice.toFixed(2)}`)
                  .fontColor($r('app.color.global_color'))

                Text(`结算(${this.totalNum})`)
                  .width(100)
                  .height(40)
                  .fontSize(20)
                  .fontColor(this.totalNum === 0 ? '#CCC' : '#FFF')
                  .borderRadius(20)
                  .textAlign(TextAlign.Center)
                  .margin({ left: 10 })
                  .linearGradient({
                    direction: GradientDirection.Left,
                    colors: [[0xFF5000, 0], [0xFF8400, 1]]
                  })
              }
            }
          }
          .width('100%')
          .height('100%')
          .borderWidth({ bottom: 1 })
          .borderColor('#CCC')
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ left: 10, right: 10 })

        }
        .width('100%')
        .height(60)
        .position({ x: 0, y: 660 })
        .backgroundColor('#FFF')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F2F2F2')

  }
}

