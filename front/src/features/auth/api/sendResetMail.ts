import type { SendResetMailParams } from '@/features/auth/types'
import axios from '@/lib/axios'

type Options = {
  params: SendResetMailParams
}

export const sendResetMail = ({ params }: Options) => axios.post('auth/password', params)
