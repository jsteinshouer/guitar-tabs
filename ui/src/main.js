import { createApp } from 'vue'
// import './style.css'
import App from './App.vue'
import router from './router'
// import '@picocss/pico/css/pico.min.css'
import './assets/custom.scss'
const app = createApp(App)
app.use(router)
app.mount('#app')
