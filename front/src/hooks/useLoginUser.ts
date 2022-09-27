import { useRecoilValue, useSetRecoilState } from 'recoil'

import { loginUserState } from '@/atoms/loginUserState'
import type { User } from '@/types/api/user'

import type { SetterOrUpdater } from 'recoil'

export const useLoginUser = () => {
  // Getterを定義
  const loginUser: User | null = useRecoilValue(loginUserState)
  // Setter, Updaterを定義
  const setLoginUser: SetterOrUpdater<User | null> = useSetRecoilState(loginUserState)

  return { loginUser, setLoginUser }
}
