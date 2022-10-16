import type { FC, ReactNode } from 'react'
import { BrowserRouter } from 'react-router-dom'

import { CookiesProvider } from 'react-cookie'
import { RecoilRoot } from 'recoil'

import { IconsSvg } from '@/components/atoms/icon/IconsSvg'
import { ToastMessage } from '@/components/organisms/layout/ToastMessage'

type AppProviderProps = {
  children: ReactNode
}

export const AppProvider: FC<AppProviderProps> = ({ children }) => (
  <CookiesProvider>
    <RecoilRoot>
      <IconsSvg />
      <ToastMessage />
      <BrowserRouter>{children}</BrowserRouter>
    </RecoilRoot>
  </CookiesProvider>
)
