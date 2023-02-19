import { useRecoilValue, useSetRecoilState } from 'recoil'

import { currentPageState, totalPageState } from '@/stores/pageState'

import type { AxiosResponseHeaders } from 'axios'

export const usePagination = () => {
  const currentPage = useRecoilValue(currentPageState)
  const setCurrentPage = useSetRecoilState(currentPageState)
  const totalPage = useRecoilValue(totalPageState)
  const setTotalPage = useSetRecoilState(totalPageState)

  type SetPage = {
    headers: AxiosResponseHeaders
  }

  const setPagination = ({ headers }: SetPage): void => {
    const newCurrentPage = parseInt(headers['current-page'], 10)
    const newTotalPage = parseInt(headers['total-pages'], 10)
    setCurrentPage(newCurrentPage)
    setTotalPage(newTotalPage)
  }

  return { currentPage, totalPage, setPagination }
}
