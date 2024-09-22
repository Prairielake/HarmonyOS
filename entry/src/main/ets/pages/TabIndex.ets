import TabHome from './TabHome'
import TabCart from './TabCart'
import TabMine from './TabMine'
import { GoodItemType } from '../data/goodList'
import { UserItemType } from '../data/userList'
import { perPage, endPage, startPage, PageType, GoodResponseType } from '../data/responseType'
import router from '@ohos.router'
import axios from '@ohos/axios'

interface BarItemType {
  title: string
  targetIndex: number
  defaultImg: Resource
  currentImg: Resource
}

interface RouterParamsType {
  index: number
}

@Entry
@Component
struct TabIndex {
  @StorageLink('user') userInfo: UserItemType = {} as UserItemType
  @StorageLink('goods') goodList: GoodItemType[] = []
  @State currentIndex: number = 0
  private tabsController: TabsController = new TabsController()
  @State barList: BarItemType[] = [
    {
      title: '首页',
      targetIndex: 0,
      defaultImg: $rawfile('img/bar/home_default.png'),
      currentImg: $rawfile('img/bar/home_current.png')
    },
    {
      title: '购物车',
      targetIndex: 1,
      defaultImg: $rawfile('img/bar/cart_default.png'),
      currentImg: $rawfile('img/bar/cart_current.png')
    },
    {
      title: '我的',
      targetIndex: 2,
      defaultImg: $rawfile('img/bar/mine_default.png'),
      currentImg: $rawfile('img/bar/mine_current.png')
    }
  ]

  @Builder
  TabBuilder(title: string, targetIndex: number, defaultImg: Resource, currentImg: Resource) {
    Column() {
      if (targetIndex === 0 && targetIndex === this.currentIndex) {
        Image(currentImg)
          .width(50)
      } else {
        Image(targetIndex === this.currentIndex ? currentImg : defaultImg)
          .width(30)

        Text(title)
          .margin({ top: 6 })
          .fontColor(targetIndex === this.currentIndex ? $r('app.color.global_color') : '#666666')
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      if (targetIndex === 1 || targetIndex === 2) {
        if (this.userInfo.id === undefined) {
          router.pushUrl({ url: 'pages/Login', params: { index: targetIndex } })
          return
        }
      }
      this.changeIndexHandler(targetIndex)
    })
  }

  //获取随机数
  getRandomNumber(a: number, b: number): number {
    return Math.floor(Math.random() * (Math.abs(a - b) + 1)) + Math.min(a, b)
  }

  //刷新商品处理器
  refreshGoodsHandler() {
    axios
      .get('http://localhost:3000/goodList',
        { params: { _page: this.getRandomNumber(startPage, endPage), _per_page: perPage } })
      .then((res: GoodResponseType<GoodItemType>) => {
        this.goodList = res.data.data
      })
  }

  //更换索引页面处理器
  changeIndexHandler(targetIndex: number) {
    this.refreshGoodsHandler()
    this.currentIndex = targetIndex
    this.tabsController.changeIndex(this.currentIndex)
  }

  aboutToAppear(): void {
    const routerParams: RouterParamsType = router.getParams() as RouterParamsType
    if (routerParams !== undefined) {
      this.changeIndexHandler(routerParams.index)
    }
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End }) {
        ForEach(this.barList, (item: BarItemType) => {
          TabContent() {
            if (this.currentIndex === 0) {
              TabHome()
            } else if (this.currentIndex === 1) {
              TabCart()
            } else if (this.currentIndex === 2) {
              TabMine()
            }
          }
          .tabBar(this.TabBuilder(item.title, item.targetIndex, item.defaultImg, item.currentImg))
        })
      }
      .width('100%')
      .height('100%')
      .barHeight(70)
      .barBackgroundColor('#FFF')
      .scrollable(false)

    }
    .width('100%')
    .height('100%')

  }
}