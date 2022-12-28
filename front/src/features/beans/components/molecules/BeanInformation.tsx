import type { FC } from 'react'

import type { Bean } from '@/features/beans/types'

type Props = {
  bean: Bean
}

export const BeanInformation: FC<Props> = (props) => {
  const { bean } = props
  return (
    <div className="grid-container grid-cols-2">
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
    </div>
  )
}
