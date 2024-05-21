<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";

const router = useRouter();

const isOpen = ref(false);
const isLogin = ref(false);
const userId = ref(0);

const props = defineProps({
  currentIndex: Number,
});

const menuList = ref([
  { id: 1, label: "プロフィール変更" },
  { id: 2, label: "メールアドレス変更" },
  { id: 3, label: "パスワード変更" },
  { id: 4, label: "退会" },
]);

onMounted(() => {
  checkLogin();
});

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
    isLogin.value = res.data.isLogin;
    userId.value = res.data.user.id;
  } catch (error) {
    isLogin.value = false;
  }
};

const showMenu = (menu) => {
  switch (menu.id) {
    case 1:
      showEditProfile();
      break;
    case 2:
      showMailAddressEdit();
      break;
    case 3:
      showPasswordEdit();
      break;
    case 4:
      break;
    default:
      break;
  }
};

const showEditProfile = () => {
  router.push({ name: "EditProfile", params: { id: userId.value } });
};

const showMailAddressEdit = () => {
  router.push({ name: "MailAddressEdit" });
};

const showPasswordEdit = () => {
  router.push({ name: "PasswordEdit" });
};
</script>

<template>
  <div class="menu-toggle" @click="isOpen = !isOpen">
    <span class="toggle-line" />
    <span class="toggle-line" />
    <span class="toggle-line" />
  </div>
  <nav class="sidebar" :class="{ open: isOpen }">
    <div class="sidebar-header">
      <span class="close-btn" @click="isOpen = false">&times;</span>
    </div>
    <div class="menu" v-for="menu in menuList">
      <div class="menu-container">
        <div class="menu-select" v-show="menu.id == currentIndex" />
        <button class="side-menu-item" @click="showMenu(menu)">
          {{ menu.label }}
        </button>
      </div>
    </div>
  </nav>
</template>

<style scoped>
.menu-toggle {
  display: none;
  cursor: pointer;
}

.toggle-line {
  display: block;
  width: 25px;
  height: 3px;
  margin: 5px auto;
  background-color: #333;
}

.sidebar {
  width: 200px;
  padding: 20px;
  margin-right: 20px;
}

.menu {
  list-style: none;
  margin: 0;
  padding: 0;
}

.menu-container {
  display: flex;
}

main {
  flex: 1;
  padding: 20px;
}

.close-btn {
  font-size: 24px;
  cursor: pointer;
}

.side-menu-item {
  padding: 6px;
  background: #f5f6f6;
  color: #000000;
  border-radius: 0px;
}

.side-menu-item:hover {
  background-color: #eae1e1;
}

.menu-select {
  width: 3px;
  background-color: #ffa500;
}

@media (max-width: 768px) {
  .menu-toggle {
    display: block;
  }

  .sidebar {
    position: fixed;
    top: 0;
    left: 0;
    height: 100%;
    width: 200px;
    background-color: #f5f6f6;
    padding: 20px;
    transform: translateX(-200px);
    transition: transform 0.3s ease-in-out;
  }

  .sidebar.open {
    transform: translateX(0);
    z-index: 100;
  }

  .sidebar-header {
    display: flex;
    justify-content: flex-end;
    margin-bottom: 20px;
  }

  .close-btn {
    display: block;
  }
}

@media (min-width: 769px) {
  .close-btn {
    display: none;
  }
}
</style>
