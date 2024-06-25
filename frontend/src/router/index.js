import { createRouter, createWebHistory } from 'vue-router';
import Home from '/src/components/page/Home.vue';
import AccountInteroduction from '/src/components/page/account/AccountIntroduction.vue';
import ConfirmAccountDelete from '/src/components/page/account/ConfirmAccountDelete.vue';
import Signup from '/src/components/page/account/Signup.vue';
import Login from '/src/components/page/account/Login.vue';
import PasswordEdit from '/src/components/page/account/PasswordEdit.vue';
import MailAddressEdit from '/src/components/page/account/MailAddressEdit.vue';
import Contact from '/src/components/page/contact/Contact.vue';
import ContactList from '/src/components/page/contact/ContactList.vue';
import ContactDetail from '/src/components/page/contact/ContactDetail.vue';
import AddRecord from '/src/components/page/record/AddRecord.vue';
import EditRecord from '/src/components/page/record/EditRecord.vue';
import RecordDetail from '/src/components/page/record/RecordDetail.vue';
import OtherRecordList from '/src/components/page/record/OtherRecordList.vue';
import KnowledgeList from '/src/components/page/knowledge/KnowledgeList.vue';
import AddKnowledge from '/src/components/page/knowledge/AddKnowledge.vue';
import EditKnowledge from '/src/components/page/knowledge/EditKnowledge.vue';
import KnowledgeDetail from '/src/components/page/knowledge/KnowledgeDetail.vue';
import UserKnowledgeList from '/src/components/page/knowledge/UserKnowledgeList.vue';
import UserProfile from '/src/components/page/user/UserProfile.vue';
import EditProfile from '/src/components/page/user/EditProfile.vue';
import UserList from '/src/components/page/user/UserList.vue';
import SupportList from '/src/components/page/user/SupportList.vue';
import SupporterList from '/src/components/page/user/SupporterList.vue';
import MyPage from '/src/components/page/user/MyPage.vue';
import NotFound from '/src/components/page/PageNotFoundError.vue';

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
    path: '/recordList/:id',
    name: 'OtherRecordList',
    component: OtherRecordList 
  },
  { 
    path: '/record/:id',
    name: 'RecordDetail',
    component: RecordDetail 
  },
  { 
    path: '/record/:id/edit',
    name: 'EditRecord',
    component: EditRecord 
  },
  { 
    path: '/user/:id',
    name: 'UserProfile',
    component: UserProfile 
  },
  { 
    path: '/user/edit/:id',
    name: 'EditProfile',
    component: EditProfile 
  },
  { 
    path: '/passwordEdit',
    name: 'PasswordEdit',
    component: PasswordEdit 
  },
  { 
    path: '/mailAddressEdit',
    name: 'MailAddressEdit',
    component: MailAddressEdit 
  },
  { 
    path: '/contact',
    name: 'Contact',
    component: Contact 
  },
  { 
    path: '/contact-list',
    name: 'ContactList',
    component: ContactList 
  },
  { 
    path: '/contact/:id',
    name: 'ContactDetail',
    component: ContactDetail 
  },
  { 
    path: '/users',
    name: 'UserList',
    component: UserList 
  },
  { 
    path: '/confirm-account-delete',
    name: 'ConfirmAccountDelete',
    component: ConfirmAccountDelete 
  },
  { 
    path: '/supportList/:id',
    name: 'SupportList',
    component: SupportList 
  },
  { 
    path: '/supporterList/:id',
    name: 'SupporterList',
    component: SupporterList 
  },
  { 
    path: '/myPage',
    name: 'MyPage',
    component: MyPage 
  },
  { 
    path: '/knowledge/user/:id',
    name: 'UserKnowledgeList',
    component: UserKnowledgeList 
  },
  { 
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: NotFound 
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router
