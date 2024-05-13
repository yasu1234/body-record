<script setup>
import axios from 'axios'
import { ref } from 'vue'
import Cookies from 'js-cookie'
import { useField, useForm } from 'vee-validate';
import * as yup from 'yup';

import Header from '../layout/Header.vue'
import ErrorMessage from '../atom/ErrorMessage.vue'

const errorMessage = ref('');

const checkValidate = async () => {
  const result = await validate()
  if (result.valid) {
    mailAddressEdit()
  }
}

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
        errorMessage.value = ''
        let errorMessages = 'メールアドレス変更に失敗しました\n';
        if (error.response.status === 422) {
            if (Array.isArray(error.response.data.errors)) {
                errorMessages += error.response.data.errors.join('\n');
            }
        }
        errorMessage.value = errorMessages
    }
}

const schema = yup.object({
  newMailAddres: yup
    .string()
    .required("この項目は必須です")
    .email("メールアドレスの形式で入力してください")
});

const { validate } = useForm({
  validationSchema: schema,
  initialValues: {
    newMailAddres: ''
  }
})

const { value: newMailAddres, errorMessage: emailError } = useField('newMailAddres');
</script>

<template>
    <Header />
    <ErrorMessage :errorMessage="errorMessage"/>
    <h1 class="signUpTitle">メールアドレス変更</h1>
    <div class="singUpInput">
        <form class="form" @submit.prevent="checkValidate">
            <div class="item">
                <label class="itemLabel" for="email">変更後のメールアドレス</label>
                <input id="email" type="email" v-model="newMailAddres">
                <p class="validation-error-message">{{ emailError }}</p>
            </div>
            <div class="signUpTitle">
                <button class="registerButton">更新</button>
            </div>
        </form>
    </div>
</template>

<style scoped>
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