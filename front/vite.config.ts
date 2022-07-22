import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

// https://vitejs.dev/config/
export default defineConfig({
  resolve: {
    alias: [{ find: '@', replacement: '/src' }]
  },
  plugins: [react()],
  server: {
    host: true, // コンテナ上で起動する際に必須
    port: 3000,
  },
});
