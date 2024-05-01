<script setup>
import axios from 'axios'
import { ref } from 'vue'
import Cookies from 'js-cookie'

import Header from './Header.vue'

const contact = ref('')

const contactSubmit = async () => {
    try {
        const formData = new FormData();
        formData.append('content', contact.value);

        const res = await axios.post(import.meta.env.VITE_APP_API_BASE + `/api/v1/contacts`, formData, {
            headers: {
                'access-token' : Cookies.get('accessToken'),
                'client':Cookies.get('client'),
                'uid': Cookies.get('uid')
            }
        })
        console.log({ res })
    } catch (error) {
        console.log({ error })
    }
}
</script>

<template>
    <Header />
    <h1 class="signUpTitle">お問合せ</h1>
    <div class="singUpInput">
        <form class="contact-form" @submit.prevent="contactSubmit">
            <div class="contact-item">
                <label class="itemLabel" for="email">要望や不適切な表現がある場合にはお問合せフォームを入力してください</label>
                <textarea name="contact" rows="20" v-model="contact"></textarea>
            </div>
            <div class="signUpTitle">
                <button class="submit-button">送信</button>
            </div>
        </form>
    </div>
</template>

<style>
.contact-form {
    width: 100%;
    margin:0 auto;
    padding: 50px;
    box-sizing: border-box;
}

.signUpTitle {
    padding-top: 40px;
    text-align: center;
}
 
.contact-item {
    padding-top: 40px;
    width: 80%;
    margin: 0 auto;
}

.itemLabel{
    display: block;
    text-align: left;
}
 
.submit-button {
    background: #ffa500;
    color: white;
    font-size:16px;
    font-weight:bold;
    padding: 10px 50px;
}
</style>