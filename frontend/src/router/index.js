import { createRouter, createWebHistory } from 'vue-router';
import Home from '/src/components/Home.vue';
import AccountInteroduction from '/src/components/AccountIntroduction.vue';
import Signup from '/src/components/Signup.vue';
import Login from '/src/components/Login.vue';
import AddRecord from '/src/components/AddRecord.vue';
import KnowledgeList from '/src/components/KnowledgeList.vue';
import AddKnowledge from '/src/components/AddKnowledge.vue';
import EditKnowledge from '/src/components/EditKnowledge.vue';
import KnowledgeDetail from '/src/components/KnowledgeDetail.vue';
import OtherRecordList from '/src/components/OtherRecordList.vue';
import RecordDetail from '/src/components/RecordDetail.vue';

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
  {
    path: '/login', 
    name: 'Login', 
    component: Login,
  },
  {
    path: '/addRecord', 
    name: 'AddRecord', 
    component: AddRecord,
  },
  {
    path: '/knowledge', 
    name: 'KnowledgeList', 
    component: KnowledgeList,
  },
  {
    path: '/addKnowledge', 
    name: 'AddKnowledge', 
    component: AddKnowledge,
  },
  { 
    path: '/knowledge/:id/edit',
    name: 'EditKnowledge',
    component: EditKnowledge 
  },
  { 
    path: '/knowledge/:id',
    name: 'KnowledgeDetail',
    component: KnowledgeDetail 
  },
  { 
    path: '/recordList',
    name: 'OtherRecordList',
    component: OtherRecordList 
  },
  { 
    path: '/record/:id',
    name: 'RecordDetail',
    component: RecordDetail 
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router