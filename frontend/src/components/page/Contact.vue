<script setup>
import axios from 'axios'
import { ref } from 'vue'
import Cookies from 'js-cookie'
import { useToast } from "primevue/usetoast";
import { toastService } from "../../const/toast.js";
import Toast from "primevue/toast";

import Header from '../layout/Header.vue'
import TabMenu from '../layout/TabMenu.vue'

const contact = ref('')
const toast = useToast();
const toastNotifications = new toastService(toast);

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
        let errorMessages = '';
        if (error.response.status === 422) {
            if (Array.isArray(error.response.data.errors)) {
                errorMessages += error.response.data.errors.join('\n');
            }
        }
        toastNotifications.displayError("お問合せ送信に失敗しました", errorMessages);
    }
}
</script>

<template>
    <Header />
    <TabMenu />
    <Toast position="top-center" />
    <h1 class="contact-top-margin">お問合せ</h1>
    <div class="contact-area">
        <form class="contact-form" @submit.prevent="contactSubmit">
            <div class="contact-item">
                <label class="itemLabel">要望や不適切な表現がある場合にはお問合せフォームを入力してください</label>
                <textarea name="contact" rows="20" v-model="contact" class="contact-text-area" />
                <p>※あくまでもポートフォリオなのでご了承ください</p>
            </div>
            <div class="contact-top-margin">
                <button class="submit-button">送信</button>
            </div>
        </form>
        <router-link :to="'contact-list'">問い合わせ一覧はこちら</router-link>
    </div>
</template>

<style scoped>
.contact-area {
    display: flex;
    flex-direction: column;
    align-items: center;
}

.contact-form {
    width: 100%;
    box-sizing: border-box;
}

.contact-top-margin {
    padding-top: 40px;
    text-align: center;
}
 
.contact-item {
    padding-top: 40px;
    width: 80%;
    margin: 0 auto;
}
.contact-text-area {
    width: 100%;
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
