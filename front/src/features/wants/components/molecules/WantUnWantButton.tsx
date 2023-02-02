import type { Dispatch, FC } from 'react'
import React, { useCallback } from 'react'

import { createWant } from '@/features/wants/api/createWant'
import { deleteWant } from '@/features/wants/api/deleteWant'
import { UnWantButton } from '@/features/wants/components/atoms/UnWantButton'
import { WantButton } from '@/features/wants/components/atoms/WantButton'
import { useMessage } from '@/hooks/useMessage'

type Props = {
  offerId: number
  wantId: number | null
  setWantId: Dispatch<React.SetStateAction<number | null>>
  wantCount: number
  setWantCount: Dispatch<React.SetStateAction<number>>
}

export const WantUnWantButton: FC<Props> = (props) => {
  const { offerId, wantId, setWantId, setWantCount, wantCount } = props
  const { showMessage } = useMessage()

  const onClickWant = () => {
    createWant({ offerId })
      .then((response) => {
        setWantId(response.data.id) // deleteリクエストで使用するurl: /wants/:idに使用
        setWantCount(wantCount + 1) // OfferCardで使用するfollower数
      })
      .catch(() => {
        showMessage({ message: 'ウォンツに失敗しました', type: 'error' })
      })
  }

  const onClickUnWant = useCallback(() => {
    if (wantId) {
      deleteWant({ id: wantId.toString() })
        .then(() => {
          setWantId(null) // want削除に伴うりセット
          setWantCount(wantCount - 1) // OfferCardで使用するfollower数
        })
        .catch(() => {
          showMessage({ message: 'ウォンツの削除に失敗しました', type: 'error' })
        })
    }
  }, [wantId, wantCount])

  return wantId ? <UnWantButton onClick={onClickUnWant} /> : <WantButton onClick={onClickWant} />
}
