<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router'
import axios from 'axios';
import Cookies from 'js-cookie'

import Header from './Header.vue'

const router = useRouter();

const isLogin = ref(false);
const userId = ref(0);
const showModal = ref(false);

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

const deleteAccount = async () => {
  try {
    const res = await axios.delete(import.meta.env.VITE_APP_API_BASE + '/api/v1/auth', {
      headers: {
        'access-token' : Cookies.get('accessToken'),
        'client':Cookies.get('client'),
        'uid': Cookies.get('uid'),
      },
    })
    
    Cookies.remove('accessToken')
    Cookies.remove('client')
    Cookies.remove('uid')
        
    router.push({ name: 'Home'})
  } catch (error) {
    console.log({ error })
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

function showModala() {
  showModal.value = true
}

function closeModal() {
  showModal.value = false
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
        <button class="account-delete-button" @click="showModala">退会する</button>
        <div v-if="showModal" class="modal-overlay">
            <div class="modal-container">
                <div class="modal-header">
                    <slot name="header">アカウントを削除します</slot>
                </div>
                <div class="modal-body">
                    <slot name="body"><p>削除すると今までの記録は消去されます<br>よろしいですか？</p></slot>
                </div>
                <div class="modal-footer">
                    <slot name="footer">
                        <button @click="deleteAccount">退会する</button>
                        <button @click="closeModal">キャンセル</button>
                    </slot>
                </div>
            </div>
        </div>
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
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;
}

.modal-container {
  background-color: #fff;
  border-radius: 5px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.33);
  padding: 20px;
  max-width: 500px;
  width: 100%;
}

.modal-header {
  margin-top: 0;
  font-size: 20px;
}

.modal-body {
  margin: 20px 0;
  line-height: 1.6;
}

.modal-footer {
  text-align: right;
}
</style>