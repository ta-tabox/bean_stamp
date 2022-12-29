export type Bean = {
  id: number
  roasterId: number
  name: string
  subregion: string | null
  farm: string | null
  variety: string | null
  elevation: number | null
  process: string | null
  croppedAt: string | null
  describe: string | null
  acidity: number
  flavor: number
  body: number
  bitterness: number
  sweetness: number
  country: string
  roastLevel: string
  tastes: string[]
  imageUrls: string[]
}

// react-hook-formで取り扱うデータの型
export type BeanCreateUpdateData = Pick<
  Bean,
  | 'name'
  | 'subregion'
  | 'farm'
  | 'variety'
  | 'elevation'
  | 'process'
  | 'croppedAt'
  | 'describe'
  | 'acidity'
  | 'flavor'
  | 'body'
  | 'bitterness'
  | 'sweetness'
> & {
  countryId: number
  // countryOption
  // roastLevelIdOption
  roastLevelId: number
  tasteTagIds: number[]
  image: string[]
}
