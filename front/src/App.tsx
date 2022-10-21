import type { FC } from 'react'

import { AppProvider } from '@/providers/app'
import { AppRouter } from '@/router'

const App: FC = () => (
  <AppProvider>
    <AppRouter />
  </AppProvider>
)

export default App
