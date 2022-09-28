import { useRecoilValue, useSetRecoilState } from 'recoil'

import type { LoginUserStateType } from '@/store/loginUserState'
import { loginUserState } from '@/store/loginUserState'

import type { SetterOrUpdater } from 'recoil'

export const useLoginUser = () => {
  // Getterを定義
  const loginUser: LoginUserStateType | null = useRecoilValue(loginUserState)
  // Setter, Updaterを定義
  const setLoginUser: SetterOrUpdater<LoginUserStateType | null> = useSetRecoilState(loginUserState)

  return { loginUser, setLoginUser }
}
