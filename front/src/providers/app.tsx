import type { FC, ReactNode } from 'react'
import { BrowserRouter } from 'react-router-dom'

import { CookiesProvider } from 'react-cookie'
import { HelmetProvider } from 'react-helmet-async'
import { RecoilRoot } from 'recoil'

import { Toast } from '@/components/Elements/Toast'
import { Head } from '@/components/Head'
import { IconsSvg } from '@/components/Icon'

type AppProviderProps = {
  children: ReactNode
}

export const AppProvider: FC<AppProviderProps> = ({ children }) => (
  <CookiesProvider>
    <RecoilRoot>
      <HelmetProvider>
        <Head />
        <IconsSvg />
        <Toast />
        <BrowserRouter>{children}</BrowserRouter>
      </HelmetProvider>
    </RecoilRoot>
  </CookiesProvider>
)
