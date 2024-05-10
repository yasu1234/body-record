<script setup>
import axios from 'axios'
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import Cookies from 'js-cookie'
import { useField, useForm } from 'vee-validate';
import * as yup from 'yup';

import Header from '../layout/Header.vue'
import ErrorMessage from '../atom/ErrorMessage.vue'

const errorMessage = ref('');

const router = useRouter();

const handleSubmit = async () => {
  const result = await validate()
  if (result.valid) {
    login()
  }
}

const login = async () => {
  try {
    const res = await axios.post(import.meta.env.VITE_APP_API_BASE + '/api/v1/auth/sign_in', {
      email: email.value,
      password: password.value
    })
    Cookies.set('accessToken', res.headers["access-token"])
    Cookies.set('client', res.headers["client"])
    Cookies.set('uid', res.headers["uid"])

    router.push({ name: 'Home'})
  } catch (error) {
    let errorMessages = 'ログインに失敗しました\n';
    if (error.response.status === 401) {
        if (Array.isArray(error.response.data.errors)) {
            errorMessages += error.response.data.errors.join('\n');
        }
    }
    errorMessage.value = errorMessages
  }
}

const schema = yup.object({
  password: yup
    .string()
    .required("この項目は必須です")
    .min(6, "6文字以上で入力してください")
    .max(128, "128文字以下で入力してください"),
  email: yup
    .string()
    .required("この項目は必須です")
    .email("メールアドレスの形式で入力してください"),
});

const { validate } = useForm({ validationSchema: schema })
const { value: password, errorMessage: passwordError } = useField('password');
const { value: email, errorMessage: emailError } = useField('email');
</script>

<template>
    <Header />
    <h1 class="signUpTitle">ログイン</h1>
    <ErrorMessage :errorMessage="errorMessage"/>
    <div class="singUpInput">
        <form class="form" @submit.prevent="handleSubmit">
            <div class="item">
                <label class="itemLabel">メールアドレス</label>
                <input id="email" type="email" v-model="email">
                <p class="validation-error-message">{{ emailError }}</p>
            </div>
            <div class="item">
                <label class="itemLabel" for="password">パスワード</label>
                <input id="password" type="password" v-model="password">
                <p class="validation-error-message">{{ passwordError }}</p>
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
