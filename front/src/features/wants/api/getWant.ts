import type { Want } from '@/features/wants/type'
import { BackendApiWithAuth } from '@/lib/axios'

type Options = {
  id: string
}

export const getWant = ({ id }: Options) => BackendApiWithAuth.get<Want>(`/wants/${id}`)
