import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  plugins: [react()],
  build: {
    outDir: 'public/assets',
    rollupOptions: {
      input: {
        main: path.resolve(__dirname, 'index.html')
      },
      output: {
        entryFileNames: 'pack_application.js',
        chunkFileNames: 'pack_application.js',
        assetFileNames: 'application.css'
      }
    }
  },
  server: {
    port: 3000
  }
})
