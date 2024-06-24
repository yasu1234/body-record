<template>
  <header>
    <h2 class="title">
      <router-link to="/" class="title">In-Body.com</router-link>
    </h2>
    <nav>
      <div class="navigation-menus">
        <button
          v-show="isLogin === false"
          class="account-introducton-button mr-7"
          @click="showAccountIntroduction"
        >
          会員登録・ログイン
        </button>
        <div @click="toggleDropdown" v-on-click-outside="onClickOutsideHandler">
          <Button
            icon="pi pi-user"
            severity="info"
            rounded
            aria-label="ユーザー"
            class="user-button"
            :pt="{
              root: {
                style: {
                  background: '#4264ec',
                },
              },
            }"
          />
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

<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { vOnClickOutside } from "@vueuse/components";
import Cookies from "js-cookie";
import Button from "primevue/button";

import { HeaderMenuList } from "../../js/const.js";
import { AccountStatusType } from "../../js/const.js";
import { axiosInstance, setupInterceptors } from "../../js/axios.js";

const router = useRouter();
setupInterceptors(router);

const isLogin = ref(null);
const userId = ref(0);
const showDropdown = ref(false);
const menuList = ref([]);

onMounted(() => {
  checkLogin();
});

const checkLogin = async () => {
  try {
    const res = await axiosInstance.get("/api/v1/users/check_login");

    isLogin.value = res.data.user !== null;
    userId.value = res.data.user.id;
    setMenu();
  } catch (error) {
    isLogin.value = false;
    setMenu();
  }
};

const logout = async () => {
  try {
    const res = await axiosInstance.delete("/api/v1/auth/sign_out");
    Cookies.remove("accessToken");
    Cookies.remove("client");
    Cookies.remove("uid");

    showHomeThenRelaod();
  } catch (error) {
    console.log({ error });
  }
};

const toggleDropdown = () => {
  showDropdown.value = !showDropdown.value;
};

const onClickOutsideHandler = () => {
  showDropdown.value = false;
};

const setMenu = () => {
  if (isLogin.value) {
    menuList.value = HeaderMenuList.filter(
      (item) =>
        item.status === AccountStatusType.shouldLogin ||
        item.status === AccountStatusType.all
    );
  } else {
    menuList.value = HeaderMenuList.filter(
      (item) =>
        item.status === AccountStatusType.unLogin ||
        item.status === AccountStatusType.all
    );
  }
};

const showMenu = (menu) => {
  switch (menu.id) {
    case 1:
      showAccountIntroduction();
      break;
    case 2:
      showMyPage();
      break;
    case 3:
      showEditProfile();
      break;
    case 4:
      logout();
      break;
    case 5:
      showContact();
      break;
    default:
      break;
  }
};

const showMyPage = () => {
  router.push({ name: "MyPage" });
};

const showAccountIntroduction = () => {
  Cookies.set("loginRoutePath", router.currentRoute.value.fullPath);
  router.push({ name: "AccountInteroduction" });
};

const showEditProfile = () => {
  router.push({ name: "EditProfile", params: { id: userId.value } });
};

const showContact = () => {
  router.push({ name: "Contact" });
};

const showHomeThenRelaod = async () => {
  await router.push({ name: "Home" });
  router.go(0);
};
</script>

<style scoped>
header {
  width: 100%;
  height: 80px;
  background: #fbf3dc;
  padding-left: 30px;
  padding-right: 30px;
  box-sizing: border-box;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.title {
  color: #ffa600;
  font-family: Comic Sans MS;
  font-weight: bold;
  font-size: 22px;
}
.navigation-menus {
  display: flex;
  justify-content: space-between;
}
.user-button {
  padding: 0;
  border: 1px solid #ccc;
  border-radius: 50%;
}
.dropdown-menu {
  position: absolute;
  background-color: #f1f1f1;
  min-width: 160px;
  box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
  z-index: 2;
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
  opacity: 1;
}
@media (max-width: 768px) {
  .account-introducton-button {
    display: none;
  }
}
</style>
