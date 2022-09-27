import type { FC } from 'react'
import { BrowserRouter } from 'react-router-dom'

import { ToastMessage } from '@/components/organisms/layout/ToastMessage'
import { Router } from '@/router/Router'

const App: FC = () => (
  <BrowserRouter>
    <ToastMessage />
    <Router />
  </BrowserRouter>
)

export default App
