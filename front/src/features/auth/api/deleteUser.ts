import { BackendApi } from '@/lib/axios'

export const deleteUserReq = () => BackendApi.delete('auth')
