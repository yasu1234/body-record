import { createRouter, createWebHistory } from 'vue-router';
import Home from '/src/components/Home.vue';
import AccountInteroduction from '/src/components/AccountIntroduction.vue';


const routes = [
  {
    path: '/', 
    name: 'Home', 
    component: Home,
  },
  {
    path: '/accountInteroduction', 
    name: 'AccountInteroduction', 
    component: AccountInteroduction,
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});
