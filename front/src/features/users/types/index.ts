export type User = {
  email: string
  image: {
    url: string | null
    thumb: {
      url: string | null
    }
  }
  id: number
  name: string
  prefectureCode: string
  describe: string | null
  roasterId: number | null
  guest: boolean
}

export type UserUpdateParams = Pick<User, 'email' | 'name' | 'prefectureCode' | 'describe'> & {
  image: string
}
