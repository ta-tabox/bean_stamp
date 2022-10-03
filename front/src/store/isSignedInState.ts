import { atom } from 'recoil'

export const isSignedInState = atom<boolean>({
  key: 'isSignedIn',
  default: false,
})
