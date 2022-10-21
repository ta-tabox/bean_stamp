import type { SendResetMailParams } from '@/features/auth/types'
import axios from '@/lib/axios'

export const sendResetMail = (params: SendResetMailParams) => axios.post('auth/password', params)
