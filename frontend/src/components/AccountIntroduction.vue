<script setup>
import { useRouter } from 'vue-router'
import axios from 'axios'
import Cookies from 'js-cookie'

const router = useRouter();

function showSignup() {
    router.push('/signup');
};

function showLogin() {
    router.push('/login');
};

const guestLogin = async () => {
  try {
    const res = await axios.post(import.meta.env.VITE_APP_API_BASE + '/api/v1/users/guest_sign_in')
    Cookies.set('accessToken', response.headers["access-token"])
    Cookies.set('client', response.headers["client"])
    Cookies.set('uid', response.headers["uid"])
  } catch (error) {
    console.log({ error })
  }
}
</script>

<template>
    <h1 class="homeTitle">理想の体を手に入れよう！</h1>
    <div class="homeContents">
        <div class="homeImage">
            <img src="../assets/image/home_image.jpg" alt="Logo" class= "homeLogo">
        </div>
        <div class="homeButtons">
            <button class="commonButton" @click="showSignup">会員登録</button>
            <button class="commonButton" @click="showLogin">ログイン</button>
            <button class="guestButton" @click="guestLogin">ゲストログイン</button>
        </div>    
    </div>
</template>

<style>
.homeContents {
    display: flex;
}
.homeLogo {      
    width:100%;
    height:auto;
    margin-top: 20px;
    object-fit: cover;
    display: block;
}
.homeTitle {      
    text-align: center;
    padding-top:10px;
}
.homeButtons {
    width:50%;
    display:flex;
    flex-direction: column;
    /* margin-left: auto;
    margin-right: auto; */
    align-items: center; /* 水平方向の中央揃え */
    margin: 0 auto; /* 要素を水平方向の中央に配置 */
}
.homeButtons button {
    width: 80%;
    margin-top: 20px;
    font-weight: bold;
    font-size: 18px;
}
.commonButton {
    background-color: #ffa500;
    font-weight: bold;
    font-size: 18px;
}
.guestButton {
    background-color: #f75549;
    font-weight: bold;
    font-size: 18px;
}
.homeImage {
    display:inline-block;
    width:50%;
}
</style>
