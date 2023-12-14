import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import './assets/custom.scss'
import "bootstrap-icons/font/bootstrap-icons.scss"

const app = createApp(App)
app.use(router)
app.mount('#app')
