<script setup>
import axios from 'axios'
import { ref } from 'vue'
import Cookies from 'js-cookie'

import Header from './Header.vue'

const newMailAddres = ref('')

const mailAddressEdit = async () => {
    try {
        const formData = new FormData();
        formData.append('email', newMailAddres.value);

        const res = await axios.put(import.meta.env.VITE_APP_API_BASE + `/api/v1/auth`, formData, {
            headers: {
                'access-token' : Cookies.get('accessToken'),
                'client':Cookies.get('client'),
                'uid': Cookies.get('uid')
            }
        })
        console.log({ res })

        Cookies.set('accessToken', res.headers["access-token"])
        Cookies.set('client', res.headers["client"])
        Cookies.set('uid', res.headers["uid"])
    } catch (error) {
        console.log({ error })
    }
}
</script>

<template>
    <Header />
    <h1 class="signUpTitle">メールアドレス変更</h1>
    <div class="singUpInput">
        <form class="form" @submit.prevent="mailAddressEdit">
            <div class="item">
                <label class="itemLabel" for="email">変更後のメールアドレス</label>
                <input id="email" type="email" v-model="newMailAddres">
            </div>
            <div class="signUpTitle">
                <button class="registerButton">更新</button>
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
 
.registerButton{
    background: #ffa500;
    color: white;
    font-size:16px;
    font-weight:bold;
    padding: 10px 50px;
}
</style>