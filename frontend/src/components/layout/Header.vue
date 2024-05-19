<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import Cookies from "js-cookie";
import axios from "axios";

const router = useRouter();

const isLogin = ref(null);
const userId = ref(0);
const showDropdown = ref(false);

onMounted(() => {
  checkLogin();
  console.log(router.currentRoute.value.fullPath);
});

const menuList = ref([
  { id: 1, label: "マイページ", isLogin: true },
  { id: 2, label: "設定", isLogin: true },
  { id: 3, label: "ログアウト", isLogin: true },
  { id: 4, label: "問い合わせ", isLogin: false },
]);

const toggleDropdown = () => {
  showDropdown.value = !showDropdown.value;
}

const checkLogin = async () => {
  try {
    const res = await axios.get(
      import.meta.env.VITE_APP_API_BASE + "/api/v1/users/check_login",
      {
        headers: {
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
      }
    );

    isLogin.value = (res.data.user !== null);
    userId.value = res.data.user.id;
  } catch (error) {
    isLogin.value = false;
  }
};


const logout = async () => {
  try {
    const res = await axios.delete(
      import.meta.env.VITE_APP_API_BASE + "/api/v1/auth/sign_out",
      {
        headers: {
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
      }
    );
    Cookies.remove("accessToken");
    Cookies.remove("client");
    Cookies.remove("uid");

    showHomeThenRelaod();
  } catch (error) {
    console.log({ error });
  }
};

const showMenu = (menu)=> {
  switch (menu.id) {
    case 1:
      showMyPage();
      break;
    case 2:
      showSetting();
      break;
    case 3:
      logout();
      break;
    case 4:
      showContact();
      break;
    default:
      break;
  }
}

const showMyPage = () => {
  router.push({ name: "UserProfile", params: { id: userId.value } });
}

const showAccountIntroduction = () => {
  router.push({ name: "AccountInteroduction" });
}

const showSetting = () => {
  router.push({ name: "Setting" });
}

const showContact = () => {
  router.push({ name: "Contact" });
}

const showHomeThenRelaod = async () => {
  await router.push({ name: "Home" });
  router.go(0);
};
</script>

<template>
  <header>
    <h2 class="title">
      <router-link to="/" class="title">In-Body.com</router-link>
    </h2>
    <nav>
      <div class="navigation-menus">
        <button
          v-show="isLogin === false"
          class="account-introducton-button"
          @click="showAccountIntroduction"
        >
          会員登録・ログイン
        </button>
        <div @click="toggleDropdown">
          <button class="user-button">
            <img
              src="../../assets/image/user-placeholder.png"
              alt="ユーザー"
              class="user-image"
            />
          </button>
        </div>
      </div>
      <div v-if="showDropdown" class="dropdown-menu">
        <button
          v-for="menu in menuList"
          class="menu-item"
          @click="showMenu(menu)"
        >
          {{ menu.label }}
        </button>
      </div>
    </nav>
  </header>
</template>

<style scoped>
header {
  width: 100%;
  height: 80px;
  background: #f6f8fa;
  padding-left: 30px;
  padding-right: 30px;
  box-sizing: border-box;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.title {
  color: #ffa600;
}
.navigation-menus {
  display: flex;
  justify-content: space-between;
}
.account-introducton-button {
  margin-right: 30px;
}
.user-button {
  padding: 0;
  background: transparent;
  border: 1px solid #ccc;
  border-radius: 50%;
}
.user-image {
  width: 40px;
  height: 40px;
}

.dropdown-menu {
  position: absolute;
  background-color: #f1f1f1;
  min-width: 160px;
  box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
  z-index: 1;
  right: 5px;
  top: 80px;
  display: flex;
  flex-direction: column;
  border-radius: 4px;
}
.menu-item {
  padding: 6px;
  background: #ffffff;
  color: #000000;
  border-radius: 0px;
}

.menu-item:hover {
  background-color: #eae1e1;
}
</style>
