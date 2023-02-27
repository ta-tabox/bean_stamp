/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_API_ORIGIN: string
  readonly VITE_FRONT_ORIGIN: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}
