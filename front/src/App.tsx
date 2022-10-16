import type { FC } from 'react'
import { useEffect } from 'react'

import { useGetCurrentUser } from '@/hooks/useGetCurrentUser'
import { AppProvider } from '@/providers/app'
import { Router } from '@/router/Router'

const App: FC = () => (
  <AppProvider>
    <Router />
  </AppProvider>
)

export default App
