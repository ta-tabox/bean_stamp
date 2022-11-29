import type { SignInParams, UserResponse } from '@/features/auth/types'
import axios from '@/lib/axios'

type Options = {
  params: SignInParams
}

export const signInWithEmailAndPassword = ({ params }: Options) => axios.post<UserResponse>('auth/sign_in', params)
