import type { FC } from "react";
import { BrowserRouter } from "react-router-dom";

import { Router } from "@/router/Router";

import "./App.css";

const App: FC = () => (
  <BrowserRouter>
    <Router />
  </BrowserRouter>
  )

export default App;
