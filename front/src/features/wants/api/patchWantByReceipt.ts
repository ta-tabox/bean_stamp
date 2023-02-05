import type { Want } from '@/features/wants/type'
import { BackendApiWithAuth } from '@/lib/axios'

type Options = {
  id: number
}

export const patchWantByReceipt = ({ id }: Options) => BackendApiWithAuth.patch<Want>(`wants/${id}/receipt`)
