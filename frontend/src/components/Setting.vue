<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router'
import axios from 'axios';

import Header from './Header.vue'

const router = useRouter();

const isLogin = ref(false);
const userId = ref(0);

onMounted(() => {
    checkLogin();
});

const checkLogin = async () => {
  try {
    const res = await axios.get(import.meta.env.VITE_APP_API_BASE + '/api/v1/users/check_login', {
      headers: {
        'access-token' : Cookies.get('accessToken'),
        'client':Cookies.get('client'),
        'uid': Cookies.get('uid'),
      },
    })
    isLogin.value = res.data.isLogin
    userId.value = res.data.user.id
  } catch (error) {
    isLogin.value = false
  }
}

function showEditProfile() {
  router.push({ name: 'EditProfile', params: { id: userId.value }})
}

function showPasswordEdit() {
  router.push({ name: 'PasswordEdit'})
}

function showMailAddressEdit() {
  router.push({ name: 'MailAddressEdit'})
}
</script>

<template>
  <Header />
  <div class="setting-list">
    <span class="section-title">プロフィール変更</span>
    <p class="section-message">目標体重や紹介文を編集できます</p>
    <button class="setting-button" @click="showEditProfile">編集する</button>
  </div>
  <div class="setting-list">
    <span class="section-title">アカウント変更</span>
    <p class="section-message">メールアドレスやパスワードを変更します</p>
    <div class="account-edit-buttons">
        <button class="setting-button" @click="showMailAddressEdit">メールアドレス編集</button>
        <button class="setting-button" @click="showPasswordEdit">パスワード編集</button>
        <button class="account-delete-button">退会する</button>
    </div>
  </div>
</template>

<style>
.setting-list {
    text-align: center;
    padding-top: 40px;
}
.section-title {
    border-bottom: solid 5px #ffa500;
    font-size:25px;
    font-weight:bold;
}
.section-message {
    font-size:20px;
}
.account-edit-buttons {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20px;
  margin-top: 20px;
}
.setting-button{
    background: #ffa500;
    color: white;
    font-size:16px;
    font-weight:bold;
}
.account-delete-button{
    background: #d50c05;
    color: white;
    font-size:16px;
    font-weight:bold;
}
</style>