import type { Bean } from '@/features/beans/types'
import { BackendApiWithAuth } from '@/lib/axios'

export const getBeans = () => BackendApiWithAuth.get<Array<Bean>>(`beans`)
