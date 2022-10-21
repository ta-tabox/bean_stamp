import type { SignUpParams, UserResponse } from '@/features/auth/types'
import axios from '@/lib/axios'

export const signUpWithSignUpParams = (params: SignUpParams) => axios.post<UserResponse>('auth', params)
