<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router'
import Cookies from 'js-cookie';

const router = useRouter();

const props = defineProps({
    isLogin: Boolean
})

function showAccountIntroduction() {
    router.push({ name: 'AccountInteroduction'})
}

</script>

<template>
    <header>
        <h2 class="title"><router-link to="/" class="title">体レコ.com</router-link></h2>
        <nav>
            <div class="navigation-buttons">
                <button v-if="!isLogin" class="account-introducton-button" @click="showAccountIntroduction">会員登録・ログイン</button>
                <button class="user-button"><img src="../assets/image/user-placeholder.png" alt="ユーザー" class="user-image"></button>
            </div>
        </nav>
    </header>
</template>

<style>
header {
    width: 100%;
    height: 80px;
    background: #f1f3ef;
    padding-left: 30px;
    padding-right: 30px;
    box-sizing: border-box;
    display: flex;
    align-items: center;
    justify-content: space-between;
    position: fixed;
    top: 0;
}
.title {
    color:#ffa600;
}
.navigation-buttons {
    display: flex;
    justify-content: space-between;
}
.account-introducton-button {
    background: #ffa500;
    margin-right: 30px;
}
.user-button {
    padding: 0;
    background: transparent;
    border: 1px solid #CCC;
    border-radius: 50%;
}
.user-image {
    width: 40px;
    height: 40px;
}
</style>