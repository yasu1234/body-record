import { createRouter, createWebHistory } from 'vue-router';
import Home from '/src/components/Home.vue';
import AccountInteroduction from '/src/components/AccountIntroduction.vue';
import Signup from '/src/components/Signup.vue';

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
  {
    path: '/signup', 
    name: 'Signup', 
    component: Signup,
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router