export interface ResponseType<T> {
  status: number
  data: T[]
}

export interface PageType<T> {
  first: number
  prev: number
  next: number
  last: number
  pages: number
  items: number
  data: T[]
}


export interface GoodResponseType<T> {
  status: number
  data: PageType<T>
}


export const perPage: number = 6

export const startPage: number = 1

export const endPage: number = 4
