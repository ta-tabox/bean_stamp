import { atom } from 'recoil'

export const currentPageState = atom<number | undefined>({
  key: 'currentPageState',
  default: undefined,
})

export const totalPageState = atom<number | undefined>({
  key: 'totalPageState',
  default: undefined,
})
