import type { FC } from 'react'
import { memo } from 'react'

import { Card, CardContainer } from '@/components/Elements/Card'
import type { Bean } from '@/features/beans/types'

type Props = {
  bean: Bean
}

export const BeanCard: FC<Props> = memo((props) => {
  const { bean } = props

  return (
    <Card>
      <CardContainer>
        <h1 className="w-11/12 mx-auto text-center pb-2 text-gray-900 text-xl lg:text-2xl title-font">{bean.name}</h1>
        <div className="w-11/12 mx-auto flex flex-col justify-center items-center">
          {/* カルーセル */}
          {/* TODO カルーセルによる画像表示 */}
          {/* <div className="swiper w-full lg:w-10/12 h-64 lg:h-96">
            <div className="swiper-wrapper">
              {bean.images.map((image) => (
                <img
                  src={image}
                  alt={`${bean.name}の画像`}
                  className="swiper-slide w-full h-full object-cover object-center rounded-lg"
                />
              ))}
            </div>
            <div className="swiper-button-next" />
            <div className="swiper-button-prev" />
            <div className="swiper-pagination" />
          </div> */}
          <div>画像を表示する</div>
          {/* render partial:'beans/images_swiper', locals: { bean: bean, cls: "w-full lg:w-10/12 h-64 lg:h-96"  */}
          <div className="text-center lg:w-10/12 w-full pt-4">
            <p className="leading-relaxed">{bean.describe}</p>
            <section className="w-11/12 mx-auto pt-4">
              <div className="mb-2 text-center text-lg e-font">〜 Flavor 〜</div>
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
              <div>tasteチャートを表示する</div>
              {/* TODO js-chartの導入 */}
              {/* <div className="h-80 w-80 sm:h-96 sm:w-96 absolute top-4 left-3">
                render partial: 'beans/taste_chart', locals: { bean: bean }
              </div> */}
            </section>
          </div>
        </div>
      </CardContainer>
    </Card>
  )
})
