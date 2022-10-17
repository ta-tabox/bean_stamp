import type { FC, ReactNode } from 'react'
import { BrowserRouter } from 'react-router-dom'

import { CookiesProvider } from 'react-cookie'
import { RecoilRoot } from 'recoil'

import { Toast } from '@/components/Elements/Toast'
import { IconsSvg } from '@/components/Icon'

type AppProviderProps = {
  children: ReactNode
}

export const AppProvider: FC<AppProviderProps> = ({ children }) => (
  <CookiesProvider>
    <RecoilRoot>
      <IconsSvg />
      <Toast />
      <BrowserRouter>{children}</BrowserRouter>
    </RecoilRoot>
  </CookiesProvider>
)
