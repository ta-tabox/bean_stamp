import type { Want } from '@/features/wants/type'
import { BackendApiWithAuth } from '@/lib/axios'

type Options = {
  id: string
}

// NOTE 返却値は何にする？
export const deleteWant = ({ id }: Options) => BackendApiWithAuth.delete<Want>(`wants/${id}`)
