import react from '@vitejs/plugin-react'
import { defineConfig, loadEnv } from 'vite'

export default defineConfig(({ command, mode }) => {
  const isProduction = mode === 'production'
  const env = loadEnv(mode, process.cwd(), '')
  const productionBaseUrl = `${env.VITE_FRONT_ORIGIN}/`
  return {
    resolve: {
      alias: [{ find: '@', replacement: '/src' }], // tsconfigのpathをviteで解決
    },
    plugins: [react()],
    server: {
      host: true, // コンテナ上で起動する際に必須
      port: 3000,
    },
    // CloudFront のディストリビューションドメイン名を設定
    base: isProduction ? productionBaseUrl : '',
  }
})
