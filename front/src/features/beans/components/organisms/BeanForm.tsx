import type { FC } from 'react'
import { useState } from 'react'

import { useForm } from 'react-hook-form'

import { PrimaryButton, SecondaryButton } from '@/components/Elements/Button'
import { ImagePreview } from '@/components/Form'
import { BeanCroppedAtInput } from '@/features/beans/components/molecules/BeanCroppedAtInput'
import { BeanDescribeInput } from '@/features/beans/components/molecules/BeanDescribeInput'
import { BeanElevationInput } from '@/features/beans/components/molecules/BeanElevationInput'
import { BeanFarmInput } from '@/features/beans/components/molecules/BeanFarmInput'
import { BeanNameInput } from '@/features/beans/components/molecules/BeanNameInput'
import { BeanProcessInput } from '@/features/beans/components/molecules/BeanProcessInput'
import { BeanSubregionInput } from '@/features/beans/components/molecules/BeanSubregionInput'
import { BeanTasteRangeInput } from '@/features/beans/components/molecules/BeanTasteRangeInput'
import { BeanVarietyInput } from '@/features/beans/components/molecules/BeanVarietyInput'
import type { BeanCreateUpdateData } from '@/features/beans/types'
import { RoasterFormCancelModal } from '@/features/roasters/components/organisms/RoasterFormCancelModal'
import { useModal } from '@/hooks/useModal'

import type { SubmitHandler } from 'react-hook-form'

type Props = {
  bean?: BeanCreateUpdateData | null
  loading: boolean
  submitTitle: string
  onSubmit: SubmitHandler<BeanCreateUpdateData>
}

export const BeanForm: FC<Props> = (props) => {
  const { bean = null, loading, submitTitle, onSubmit } = props
  const { isOpen, onOpen, onClose } = useModal()

  const [previewImage, setPreviewImage] = useState<Array<string>>()

  // フォーム初期値の設定 RoasterNew -> {}, Roaster Edit -> {初期値}
  const defaultValues = () => {
    let values: BeanCreateUpdateData | undefined
    if (bean) {
      // TODO 外部キーを保存している要素に対して同様の処理を行う
      // codeId -> 配列のindexへ変換
      // const prefectureCodeIndex = convertPrefectureCodeToIndex(bean.prefectureCode)
      values = {
        name: bean.name,
        subregion: bean.subregion,
        farm: bean.farm,
        variety: bean.variety,
        elevation: bean.elevation,
        process: bean.process,
        croppedAt: bean.croppedAt,
        describe: bean.describe,
        acidity: bean.acidity,
        flavor: bean.flavor,
        body: bean.body,
        bitterness: bean.bitterness,
        sweetness: bean.sweetness,
        countryId: bean.countryId, // indexに合わせる必要があるかも
        roastLevelId: bean.roastLevelId, // indexに合わせる必要があるかも
        tasteTagIds: bean.tasteTagIds,
        image: bean.image,
        // prefectureOption: prefectureOptions[prefectureCodeIndex],
      }
    }
    return values
  }

  const {
    register,
    handleSubmit,
    formState: { isDirty, dirtyFields, errors },
    control,
  } = useForm<BeanCreateUpdateData>({
    criteriaMode: 'all',
    defaultValues: defaultValues(),
  })

  const onClickCancel = (): void => {
    // キャンセル確認モーダルオープン
    onOpen()
  }

  // プレビュー機能
  // const onChangeImage = (e: ChangeEvent<HTMLInputElement>) => {
  //   if (e.target.files && e.target.files.length) {
  //     // WARNING ChromeではURL.createObjectURLは廃止予定？変更する必要があるかもしれない
  //     setPreviewImage([URL.createObjectURL(e.target.files[0])])
  //   }
  // }

  return (
    <>
      <h2 className="e-font text-gray-500 text-center text-sm">〜 Images 〜</h2>
      {/* TODO 既存画像のカルーセル表示 */}
      {bean && <div>カルーセルを表示</div>}

      <form onSubmit={handleSubmit(onSubmit)}>
        {/* プレビューフィールド */}
        {previewImage && <ImagePreview images={previewImage} />}
        {/* 画像インプット */}
        {/* <BeanImageInput label="image" register={register} error={errors.image ?errors.image[0] } onChange={onChangeImage} /> */}
        <section className="mt-4">
          <h2 className="e-font text-gray-500 text-center text-sm">〜 Detail 〜</h2>
          {/* タイトル */}
          <BeanNameInput label="name" register={register} error={errors.name} />
          {/* 生産国 セレクト */}
          {/* 焙煎度 セレクト */}
          {/* 地域 */}
          <BeanSubregionInput label="subregion" register={register} />

          {/* 農園 */}
          <BeanFarmInput label="farm" register={register} />

          {/* 品種 */}
          <BeanVarietyInput label="variety" register={register} />

          {/* 標高 */}
          <BeanElevationInput label="elevation" register={register} error={errors.elevation} />

          {/* 精製方法 */}
          <BeanProcessInput label="process" register={register} />

          {/* 収穫期 */}
          <BeanCroppedAtInput label="croppedAt" register={register} />

          {/* 紹介文 */}
          <BeanDescribeInput label="describe" register={register} error={errors.describe} />
        </section>
        {/* テイスト */}
        <section className="mt-4 w-11/12 sm:w-2/3 md:w-full mx-auto md:grid md:grid-cols-2 md:content-between">
          <h2 className="md:col-span-2 text-gray-500 text-center text-sm">〜 Taste 〜</h2>
          <BeanTasteRangeInput name="酸味" label="acidity" register={register} />
          <BeanTasteRangeInput name="フレーバー" label="flavor" register={register} />
          <BeanTasteRangeInput name="ボディ" label="body" register={register} />
          <BeanTasteRangeInput name="苦味" label="bitterness" register={register} />
          <BeanTasteRangeInput name="甘味" label="sweetness" register={register} />
        </section>
        {/* テイストタグ */}
        <section className="my-4">
          <h2 className="e-font text-gray-500 text-center text-sm">〜 Flavor 〜</h2>
        </section>
        <div className="flex items-center justify-center space-x-4 mt-4">
          <SecondaryButton onClick={onClickCancel} isButton>
            キャンセル
          </SecondaryButton>
          {/* beanあり(更新時)→ どれか変更, なし(新規作成時)→ 該当項目変更必須 */}
          <PrimaryButton disabled={bean ? !isDirty : !dirtyFields.name} loading={loading}>
            {submitTitle}
          </PrimaryButton>
        </div>
      </form>
      <RoasterFormCancelModal isOpen={isOpen} onClose={onClose} />
    </>
  )
}
