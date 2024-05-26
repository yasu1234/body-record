import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router'
import PrimeVue from 'primevue/config';
import 'primevue/resources/primevue.min.css'
import 'primeicons/primeicons.css'
import ToastService from 'primevue/toastservice';

const app = createApp(App);
app.use(router);
app.use(PrimeVue);
app.use(ToastService);
app.mount('#app');
