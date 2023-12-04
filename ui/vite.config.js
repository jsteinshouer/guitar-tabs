import { defineConfig, loadEnv } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig(({ command, mode }) => {
  const env = loadEnv(mode, process.cwd(), '')
  console.log(env)
  return { 
  plugins: [vue()],
  server: {
    port: 8081,
    proxy: {
      '/api': {
          target: env.BACKEND_URL,
          changeOrigin: true,
          cookieDomainRewrite: "localhost"
      },
      '/tests': {
        target: env.BACKEND_URL,
        changeOrigin: true,
        cookieDomainRewrite: "localhost"
      }
    }
  }
  }
})
