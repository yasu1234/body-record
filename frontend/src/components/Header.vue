<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router'
import Cookies from 'js-cookie';
import axios from 'axios';

const router = useRouter();

const isLogin = ref(false);

onMounted(() => {
    checkLogin();
});

const menuList = ref([
  { id: 1, label: "ユーザー設定", isLogin: true },
  { id: 2, label: "設定", isLogin: false },
  { id: 3, label: "ログアウト", isLogin: true }
]);

const checkLogin = async () => {
  try {
    const res = await axios.get(import.meta.env.VITE_APP_API_BASE + '/api/v1/users/check_login', {
      headers: {
        'access-token' : Cookies.get('accessToken'),
        'client':Cookies.get('client'),
        'uid': Cookies.get('uid'),
      },
    })
    isLogin.value = res.data.isLogin
  } catch (error) {
    console.log({ error })
  }
}

const showDropdown = ref(false);

function showAccountIntroduction() {
    router.push({ name: 'AccountInteroduction'})
}

function toggleDropdown() {
  showDropdown.value = !showDropdown.value;
}

function showMenu(menu) {
}
</script>

<template>
    <header>
        <h2 class="title"><router-link to="/" class="title">体レコ.com</router-link></h2>
        <nav>
            <div class="navigation-buttons">
                <button v-if="!isLogin" class="account-introducton-button" @click="showAccountIntroduction">会員登録・ログイン</button>
                <div @click="toggleDropdown">
                    <button class="user-button"><img src="../assets/image/user-placeholder.png" alt="ユーザー" class="user-image"></button>
                </div>                
            </div>
            <div v-if="showDropdown" class="dropdown-menu">
                <div v-for="menu in menuList" class="menu-item" @click="showMenu(menu)">
                    {{ menu.label }}
                </div>
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

.user-dropdown {
  position: relative;
  display: inline-block;
}

.dropdown-menu {
  position: absolute;
  background-color: #f1f1f1;
  min-width: 160px;
  box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
  z-index: 1;
  right: 5px;
  top: 80px;
  display: flex;
  flex-direction: column;
  border-radius: 4px;
}
.menu-item {
  padding: 6px;
}
</style>