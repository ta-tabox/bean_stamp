import type { FC } from 'react'

import { Card, CardContainer } from '@/components/Elements/Card'
import { BeanTasteTags } from '@/features/beans/components/molecules/BeanTasteTags'
import { BeanImagesSwiper } from '@/features/beans/components/organisms/BeanImagesSwiper'
import { BeanTasteChart } from '@/features/beans/components/organisms/BeanTasteChart'
import type { Bean } from '@/features/beans/types'

type Props = {
  bean: Bean
}

export const BeanCard: FC<Props> = (props) => {
  const { bean } = props

  return (
    <Card>
      <CardContainer>
        <h1 className="w-11/12 mx-auto text-center pb-2 text-gray-900 text-xl lg:text-2xl title-font">{bean.name}</h1>
        <div className="w-11/12 mx-auto flex flex-col justify-center items-center">
          {/* カルーセル */}
          <BeanImagesSwiper imageUrls={bean.imageUrls} beanName={bean.name} />

          <div className="text-center lg:w-10/12 w-full pt-4">
            <p className="leading-relaxed">{bean.describe}</p>
            <section className="w-11/12 mx-auto pt-4">
              <div className="mb-2 text-center text-lg e-font">〜 Flavor 〜</div>
              <BeanTasteTags tastes={bean.tastes} />
              {/* render partial: 'beans/taste_tag', locals: { bean: bean } */}
            </section>
            <section className="pt-4 grid-container grid-cols-2">
              <div className="col-span-2 mb-2 text-lg e-font">〜 Detail 〜</div>
              <div className="grid-item">
                <span className="text-gray-500">生産国</span>
                <span className="ml-auto text-gray-900"> {bean.country}</span>
              </div>
              <div className="grid-item">
                <span className="text-gray-500">焙煎度</span>
                <span className="ml-auto text-gray-900">{bean.roastLevel}</span>
              </div>
              <div className="grid-item">
                <span className="text-gray-500">地域</span>
                <span className="ml-auto text-gray-900"> {bean.subregion}</span>
              </div>
              <div className="grid-item">
                <span className="text-gray-500">農園</span>
                <span className="ml-auto text-gray-900"> {bean.farm}</span>
              </div>
              <div className="grid-item">
                <span className="text-gray-500">品種</span>
                <span className="ml-auto text-gray-900"> {bean.variety}</span>
              </div>
              <div className="grid-item">
                <span className="text-gray-500">精製方法</span>
                <span className="ml-auto text-gray-900"> {bean.process}</span>
              </div>
              <div className="grid-item">
                <span className="text-gray-500">標高</span>
                <span className="ml-auto text-gray-900"> {`${bean.elevation ?? ''} m`} </span>
              </div>
              <div className="grid-item">
                <span className="text-gray-500">収穫</span>
                <span className="ml-auto text-gray-900">{bean.croppedAt}</span>
              </div>
            </section>
            <section className="pt-4 h-80 w-80 sm:h-96 sm:w-96 mx-auto relative">
              <div className="text-lg e-font">〜 Taste 〜</div>
              <div className="h-80 w-80 sm:h-96 sm:w-96 absolute top-4 left-3">
                {/* Tasteチャート */}
                <BeanTasteChart
                  acidity={bean.acidity}
                  flavor={bean.flavor}
                  body={bean.body}
                  bitterness={bean.bitterness}
                  sweetness={bean.sweetness}
                />
              </div>
            </section>
          </div>
        </div>
      </CardContainer>
    </Card>
  )
}
