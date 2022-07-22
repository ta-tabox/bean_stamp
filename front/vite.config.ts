import react from "@vitejs/plugin-react";
import { defineConfig } from "vite";

export default defineConfig({
  resolve: {
    alias: [{ find: '@', replacement: '/src' }] // tsconfigのpathをviteで解決
  },
  plugins: [react()],
  server: {
    host: true, // コンテナ上で起動する際に必須
    port: 3000,
  },
});
