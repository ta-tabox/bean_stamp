import type { Want } from '@/features/wants/type'
import { BackendApiWithAuth } from '@/lib/axios'

type Props = {
  page: string | null
  status: string
}

export const getWantsWithSearch = ({ page, status }: Props) =>
  BackendApiWithAuth.get<Array<Want>>(`/wants?page=${page ?? 1}&search=${status}`)
