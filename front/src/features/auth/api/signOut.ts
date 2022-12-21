import { BackendApi } from '@/lib/axios'

export const signOutReq = () => BackendApi.get('auth/sign_out')
