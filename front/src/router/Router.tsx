import type { FC } from 'react'
import { Route, Routes } from 'react-router-dom'

import { About } from '@/components/pages/common/About'
import { Home } from '@/components/pages/common/Home'

export const Router: FC = () => (
  <Routes>
    <Route path="/" element={<Home />} />
    <Route path="about" element={<About />} />
  </Routes>
)
