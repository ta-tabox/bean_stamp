import { getOffersStats as getOffersStatsRequest } from '@/features/offers/api/getOffersStats'
import { useOffersStats } from '@/features/offers/hooks/useOffersStats'
import { useMessage } from '@/hooks/useMessage'

export const useGetOffersStats = () => {
  const { showMessage } = useMessage()
  const { offersStats, setOffersStats } = useOffersStats()

  const getOffersStats = () => {
    getOffersStatsRequest()
      .then((response) => {
        setOffersStats(response.data)
      })
      .catch(() => {
        showMessage({ message: 'オッファーの集計の取得に失敗しました', type: 'error' })
      })
  }

  return { offersStats, getOffersStats }
}
