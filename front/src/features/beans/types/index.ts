import type { CountryOption } from '@/features/beans/utils/country'
import type { RoastLevelOption } from '@/features/beans/utils/roastLevel'
import type { TasteTagOption } from '@/features/beans/utils/tasteTag'

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

// Create, Update時のAPIリクエスト、レスポンス用の型
export type BeanApiType = Pick<
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
  roastLevelId: number
  tasteTagIds: number[]
  images: string[]
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
  countryOption: CountryOption
  roastLevelOption: RoastLevelOption
  tasteTagOptions: Array<TasteTagOption>
  // tasteTagOption1: TasteTagOption
  // tasteTagOption2: TasteTagOption
  // tasteTagOption3: TasteTagOption
  // tasteTagIds: number[]
  images?: FileList
}
