import type { FC } from 'react'

import { Helmet } from 'react-helmet-async'

import { APP_NAME, FRONT_HOST } from '@/config'

type HeadProps = {
  title?: string
  description?: string
  path?: string
}

export const Head: FC<HeadProps> = (props) => {
  const { title, description, path } = props

  return (
    <Helmet title={title ? `${title} | ${APP_NAME}` : undefined} defaultTitle={`${APP_NAME}`}>
      <meta name="description" content={description ?? 'Bean Stampはコーヒー愛好家とロースターを繋ぐサービスです。'} />
      <link rel="canonical" href={`${FRONT_HOST}/${path ?? ''}`} />

      <link rel="icon" type="image/svg+xml" href="#" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      {/* fontawesomeの読み込み */}
      <script src="https://kit.fontawesome.com/2a4ad365af.js" crossOrigin="anonymous" />
    </Helmet>
  )
}
