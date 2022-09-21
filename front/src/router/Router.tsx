import type { FC } from 'react'
import { Route, Routes } from 'react-router-dom'

import { About } from '@/components/pages/common/About'
import { Home } from '@/components/pages/common/Home'
import { SignIn } from '@/components/pages/common/SingIn'
import { SignUp } from '@/components/pages/common/SingUp'

export const Router: FC = () => (
  <Routes>
    <Route path="/" element={<Home />} />
    <Route path="about" element={<About />} />
    <Route path="signup" element={<SignUp />} />
    <Route path="signin" element={<SignIn />} />
  </Routes>
)
