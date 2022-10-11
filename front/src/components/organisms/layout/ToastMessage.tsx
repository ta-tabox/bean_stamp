import type { FC } from 'react'
import { memo } from 'react'

import { ToastContainer, Slide } from 'react-toastify'
import 'react-toastify/dist/ReactToastify.css'

export const ToastMessage: FC = memo(() => (
  <ToastContainer
    position="bottom-right"
    autoClose={3000}
    hideProgressBar
    newestOnTop={false}
    closeOnClick
    rtl={false}
    pauseOnFocusLoss
    draggable
    pauseOnHover
    transition={Slide}
    closeButton={false}
    limit={3}
  />
))
