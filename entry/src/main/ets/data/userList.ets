export interface UserItemType {
  id: number
  nickname: string
  accept: string
  password: string
  avatar: string
}

const userList: UserItemType[] = [
  {
    "id": 1,
    "nickname": "zhangsan123",
    "accept": "zhangsan",
    "password": "123",
    "avatar": "https://gw.alicdn.com/sns_logo/TB1e4rMt8Bh1e4jSZFhXXcC9VXa-240-240.png_120x120.jpg_.webp"
  },
  {
    "id": 2,
    "nickname": "lisi123",
    "accept": "lisi",
    "password": "123",
    "avatar": "https://gw.alicdn.com/sns_logo/TB1e4rMt8Bh1e4jSZFhXXcC9VXa-240-240.png_120x120.jpg_.webp"
  },
  {
    "id": 3,
    "nickname": "wangwu123",
    "accept": "wangwu",
    "password": "123",
    "avatar": "https://gw.alicdn.com/sns_logo/TB1e4rMt8Bh1e4jSZFhXXcC9VXa-240-240.png_120x120.jpg_.webp"
  }
]

export default userList
