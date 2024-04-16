<script setup>
import axios from 'axios'
import { ref } from 'vue'
import Cookies from 'js-cookie'

import Header from './Header.vue'

const email = ref('')
const password = ref('')

const login = async () => {
  try {
    const res = await axios.post(import.meta.env.VITE_APP_API_BASE + '/api/v1/auth/sign_in', {
      email: email.value,
      password: password.value
    })
    Cookies.set('accessToken', response.headers["access-token"])
    Cookies.set('client', response.headers["client"])
    Cookies.set('uid', response.headers["uid"])

    router.push({ name: 'Home'})
  } catch (error) {
    console.log({ error })
  }
}
</script>

<template>
    <Header />
    <h1 class="signUpTitle">ログイン</h1>
    <div class="singUpInput">
        <form class="form" @submit.prevent="login">
            <div class="item">
                <label class="itemLabel">メールアドレス</label>
                <input id="email" type="email" v-model="email">
            </div>
            <div class="item">
                <label class="itemLabel" for="password">パスワード</label>
                <input id="password" type="password" v-model="password">
            </div>
            <div class="signUpTitle">
                <button class="loginButton">ログイン</button>
            </div>
        </form>
    </div>
</template>

<style>
.form{
   width: 100%;
   margin:0 auto;
   padding: 50px;
   box-sizing: border-box;
}

.signUpTitle {
    padding-top: 40px;
    text-align: center;
}
 
.item{
    padding-top: 40px;
    width: 50%;
    margin: 0 auto;
}

.itemLabel{
    display: block;
    text-align: left;
}

.error-message{
    width: 50%;
    margin: 0 auto;
}
 
.error-message-text{
    color: red;
    font-size: 15px;
}

.form input[type="email"],
.form input[type="password"] {
     padding: 10px;
     width: 100%;
 }
 
.form textarea{
   padding: 10px;
   height: 100px;
   font-size: 14px;
   width: 50%;
 }
 
.loginButton{
    background: #ffa500;
    color: white;
    font-size:16px;
    font-weight:bold;
    padding: 10px 50px;
}
</style>
