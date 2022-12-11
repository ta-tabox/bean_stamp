export type Roaster = {
  id: number
  name: string
  phoneNumber: string
  prefectureCode: string
  describe: string | null
  image: {
    url: string | null
    thumb: {
      url: string | null
    }
  }
  address: string
  guest: boolean
}

export type RoasterCreateParams = Pick<Roaster, 'name' | 'phoneNumber' | 'prefectureCode' | 'describe' | 'address'> & {
  image: string
}
