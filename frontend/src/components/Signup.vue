<script setup>
import axios from 'axios'
import { ref } from 'vue'

defineProps({
  msg: String,
})

const email = ref('')
const password = ref('')
const passwordConfirm = ref('')
const name = ref('')

const signup = async () => {
  try {
    const res = await axios.post(import.meta.env.VITE_APP_API_BASE + '/api/v1/auth', {
      email: email.value,
      password: password.value,
      password_confirmation: passwordConfirm.value,
      name: name.value
    })
    console.log(res.data)
  } catch (error) {
    console.log({ error })
  }
}
</script>

<template>
    <h1 class="signUpTitle">会員登録</h1>
    <div class="singUpInput">
        <form class="form" @submit.prevent="signup">
            <div class="item">
                <label class="itemLabel">メールアドレス</label>
                <input id="email" type="email" v-model="email">
            </div>
            <div class="item">
                <label class="itemLabel" for="password">パスワード</label>
                <input id="password" type="password" v-model="password">
            </div>
            <div class="item">
                <label class="itemLabel" for="passwordConfirm">パスワード(確認)</label>
                <input id="passwordConfirm" type="password" v-model="passwordConfirm">
            </div>
            <div class="item">
                <label class="itemLabel" for="name">名前</label>
                <input id="name"  type="text" v-model="name">
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
