<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import Cookies from 'js-cookie'
import axios from 'axios'
import { useField, useForm } from 'vee-validate';
import * as yup from 'yup';

import Header from '../layout/Header.vue'

const router = useRouter();

defineProps({
  msg: String,
})

const checkValidate = async () => {
  const result = await validate()
  if (result.valid) {
    signup()
  }
}

const signup = async () => {
  try {
    const res = await axios.post(import.meta.env.VITE_APP_API_BASE + '/api/v1/auth', {
      email: email.value,
      password: password.value,
      password_confirmation: passwordConfirm.value,
      name: name.value
    })
    Cookies.set('accessToken', res.headers["access-token"])
    Cookies.set('client', res.headers["client"])
    Cookies.set('uid', res.headers["uid"])

    router.push({ name: 'Home'})
  } catch (error) {
    console.log({ error })
  }
}

const schema = yup.object({
  password: yup
    .string()
    .required("この項目は必須です")
    .min(6, "6文字以上で入力してください")
    .max(128, "128文字以下で入力してください"),
  passwordConfirm: yup
    .string()
    .required("この項目は必須です")
    .min(6, "6文字以上で入力してください")
    .max(128, "128文字以下で入力してください"),
  email: yup
    .string()
    .required("この項目は必須です")
    .email("メールアドレスの形式で入力してください"),
  name: yup
    .string()
    .required("この項目は必須です"),
});

const { validate } = useForm({
  validationSchema: schema,
  initialValues: {
    password: '',
    passwordConfirm: '',
    email: '',
    name: ''
  }
})

const { value: password, errorMessage: passwordError } = useField('password');
const { value: passwordConfirm, errorMessage: passwordConfirmError } = useField('passwordConfirm');
const { value: email, errorMessage: emailError } = useField('email');
const { value: name, errorMessage: nameError } = useField('name');
</script>

<template>
    <Header />
    <h1 class="signUpTitle">会員登録</h1>
    <div class="singUpInput">
        <form class="form" @submit.prevent="checkValidate">
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
            <div class="item">
                <label class="itemLabel" for="passwordConfirm">パスワード(確認)</label>
                <input id="passwordConfirm" type="password" v-model="passwordConfirm">
                <p class="validation-error-message">{{ passwordConfirmError }}</p>
            </div>
            <div class="item">
                <label class="itemLabel" for="name">名前</label>
                <input id="name"  type="text" v-model="name">
                <p class="validation-error-message">{{ nameError }}</p>
            </div>
            <div class="signUpTitle">
                <button class="registerButton">登録</button>
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

 /* 入力欄にpadding追加 */
.form input[type="email"],
.form input[type="password"],
.form input[type="text"] {
     padding: 10px;
     width: 100%;
 }
 
.form textarea{
   padding: 10px;
   height: 100px;
   font-size: 14px;
   width: 50%;
 }
 
.registerButton{
    background: #ffa500;
    color: white;
    font-size:16px;
    font-weight:bold;
    padding: 10px 50px;
}
</style>
