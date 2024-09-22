import GoodItem from '../components/GoodItem'
import { GoodItemType } from '../data/goodList'
import { CartItemType } from '../data/cartList'
import { UserItemType } from '../data/userList'
import { ResponseType } from '../data/responseType'
import router from '@ohos.router'
import axios from '@ohos/axios'

interface RouterParamsType {
  goodId: number
}

@Entry
@Component
struct Detail {
  @State isAdShow: boolean = true
  @State isRender: boolean = false
  @State goodInfo: GoodItemType = {} as GoodItemType
  @StorageLink('user') userInfo: UserItemType = {} as UserItemType
  @StorageLink('cart') cartList: CartItemType[] = []
  @StorageLink('goods') goodList: GoodItemType[] = []

  aboutToAppear(): void {
    axios
      .get('http://localhost:3000/goodList')
      .then((res: ResponseType<GoodItemType>) => {
        const routerParams: RouterParamsType = router.getParams() as RouterParamsType
        const goodInfo: GoodItemType =
          res.data.find((item: GoodItemType) => item.id === routerParams.goodId) as GoodItemType
        this.goodInfo = goodInfo
        this.isRender = true
      })
  }

  build() {
    Column() {
      //固定部分
      Column() {
        if (this.isAdShow) {
          Row() {
            Stack() {
              Image($rawfile('img/detail/ad.jpg'))
                .width('100%')

              Image($rawfile('img/detail/close.png'))
                .width(15)
                .margin({ left: 320 })
                .onClick(() => {
                  this.isAdShow = false
                })
            }
          }
        }
      }

      //滑动部分
      Scroll() {
        Column() {
          //顶部通栏
          Row() {
            //返回
            Stack() {
              Circle({ width: 40, height: 40 })
                .fill('#CCCCCCCC')
              Image($rawfile('img/detail/back.png'))
                .width(25)
            }
            .onClick(() => {
              router.back()
            })

            //购物车
            Stack() {
              Circle({ width: 40, height: 40 })
                .fill('#CCCCCCCC')
              Image($rawfile('img/detail/cart.png'))
                .width(25)
            }
            .onClick(() => {
              if (this.userInfo.id === undefined) {
                router.pushUrl({ url: 'pages/Login', params: { index: 1 } })
                return
              }
              router.pushUrl({ url: 'pages/TabIndex', params: { index: 1 } })
            })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .height(50)
          .padding({ left: 20, right: 20, top: 20 })

          .position({ x: 0, y: 0 })
          .zIndex(9999)


          if (this.isRender) {
            Image(this.goodInfo.img)
              .width('100%')

            Column() {
              Row() {
                Text('优惠促销')
                  .fontSize(18)
                  .fontColor($r('app.color.global_color'))
              }
              .width('100%')
              .padding({ top: 10, left: 20 })

              //商品价格
              Row() {
                Text('￥')
                  .fontSize(24)
                  .fontWeight(400)
                  .fontColor($r('app.color.global_color'))
                  .padding({ top: 6 })

                Text(this.goodInfo.price.toString())
                  .fontSize(36)
                  .fontWeight(400)
                  .fontColor($r('app.color.global_color'))
              }
              .width('100%')
              .padding({ left: 18 })

              //商品销量
              Row() {
                Image($rawfile('img/detail/cat.png'))
                  .width(50)

                Text(`已售${this.goodInfo.count}+`)
                  .fontSize(18)
                  .fontColor(Color.Gray)
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({ left: 20, right: 20 })
              .margin({ top: 20 })

              //商品介绍
              Text(this.goodInfo.desc)
                .width('100%')
                .fontSize(20)
                .fontWeight(400)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Clip })
                .padding({ left: 15, right: 15 })
                .margin({ top: 20 })

            }
            .width('96%')
            .backgroundColor('#FFF')
            .borderRadius(10)
            .padding({ top: 20, bottom: 20 })
            .margin({ top: 10 })
          }


          //你可能还喜欢
          Image($rawfile('img/cart/like.png'))
            .width(200)
            .margin({ top: 30, bottom: 20 })

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
      .layoutWeight(1)
      .scrollBarWidth(0)


      //底部固定部分
      Row() {
        //店铺
        Column() {
          Image($rawfile('img/detail/shop.png'))
            .height(30)
          Text('店铺')
            .fontSize(12)
        }

        //客服
        Column() {
          Image($rawfile('img/detail/server.png'))
            .height(30)
          Text('客服')
            .fontSize(12)
        }

        //收藏
        Column() {
          Image($rawfile('img/detail/collect.png'))
            .height(30)
          Text('收藏')
            .fontSize(12)
        }

        Row() {
          Text('加入购物车')
            .width(100)
            .height(40)
            .fontSize(16)
            .fontWeight(600)
            .fontColor('#FFF')
            .textAlign(TextAlign.Center)
            .borderRadius({ topLeft: 20, bottomLeft: 20 })
            .borderWidth({ right: 0.01 })
            .borderColor('#CCC')
            .linearGradient({
              direction: GradientDirection.Left,
              colors: [[0xFF9000, 0.5], [0xFFC000, 1]]
            })
            .onClick(() => {
              if (this.userInfo.id === undefined) {
                router.pushUrl({ url: 'pages/Login', params: { index: 1 } })
                return
              }
              if (this.cartList.length === 0) {
                this.cartList.push({
                  id: this.goodInfo.id,
                  img: this.goodInfo.img,
                  desc: this.goodInfo.desc,
                  price: this.goodInfo.price,
                  count: this.goodInfo.count,
                  buyNum: 1,
                  isSelect: false
                })
                return
              }

              const info: CartItemType | undefined =
                this.cartList.find((item: CartItemType) => item.id === this.goodInfo.id) as CartItemType
              if (info === undefined) {
                this.cartList.push({
                  id: this.goodInfo.id,
                  img: this.goodInfo.img,
                  desc: this.goodInfo.desc,
                  price: this.goodInfo.price,
                  count: this.goodInfo.count,
                  buyNum: 1,
                  isSelect: false
                })
                return
              }
              info.buyNum++
            })

          Text('立即购买')
            .width(100)
            .height(40)
            .fontSize(16)
            .fontWeight(600)
            .fontColor('#FFF')
            .textAlign(TextAlign.Center)
            .borderRadius({ topRight: 20, bottomRight: 20 })
            .linearGradient({
              direction: GradientDirection.Left,
              colors: [[0xFF5000, 0.5], [0xFF9000, 1]]
            })
        }

      }
      .width('100%')
      .height(60)
      .padding({ left: 10, right: 10 })
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor('#FFF')

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F1F1')

  }
}