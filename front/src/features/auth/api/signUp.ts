import type { SignUpParams, UserResponse } from '@/features/auth/types'
import axios from '@/lib/axios'

type Options = {
  params: SignUpParams
}

export const signUpWithSignUpParams = ({ params }: Options) => axios.post<UserResponse>('auth', params)
