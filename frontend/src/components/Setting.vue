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
    <button class="setting-button">編集する</button>
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
.setting-button{
    background: #ffa500;
    color: white;
    font-size:16px;
    font-weight:bold;
    margin-top: 20px;
}
</style>