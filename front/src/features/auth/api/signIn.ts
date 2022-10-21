import type { SignInParams, UserResponse } from '@/features/auth/types'
import axios from '@/lib/axios'

export const signInWithEmailAndPassword = (params: SignInParams) => axios.post<UserResponse>('auth/sign_in', params)
