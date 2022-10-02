import React from 'react'
import ReactDOM from 'react-dom/client'
import './index.css'

import { CookiesProvider } from 'react-cookie'
import { RecoilRoot } from 'recoil'

import App from '@/App'

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
  <React.StrictMode>
    <CookiesProvider>
      <RecoilRoot>
        <App />
      </RecoilRoot>
    </CookiesProvider>
  </React.StrictMode>
)
