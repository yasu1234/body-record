<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import axios from "axios";
import Cookies from "js-cookie";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../const/toast.js";
import Toast from "primevue/toast";

const router = useRouter();
const toast = useToast();
const toastNotifications = new toastService(toast);

const showSignup = () => {
  router.push("/signup");
};

const showLogin = () => {
  router.push("/login");
};

const guestLogin = async () => {
  try {
    const res = await axios.post(
      import.meta.env.VITE_APP_API_BASE + "/api/v1/users/guest_sign_in"
    );
    Cookies.set("accessToken", res.headers["access-token"]);
    Cookies.set("client", res.headers["client"]);
    Cookies.set("uid", res.headers["uid"]);

    router.push({ name: "Home" });
  } catch (error) {
    let errorMessages = "";
    if (error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      }
    }
    toastNotifications.displayError("ゲストログインに失敗しました", errorMessages)
  }
};
</script>

<template>
  <Toast position="top-center" />
  <img src="../../assets/image/home_image.jpg" alt="Logo" class="home-logo" />
  <h1 class="account-introduction-title">Inbody-Recordへようこそ！</h1>
  <div class="account-buttons">
    <button class="account-button" @click="showSignup">会員登録</button>
    <button class="account-button" @click="showLogin">ログイン</button>
    <button class="guest-login-button" @click="guestLogin">
      ゲストログイン
    </button>
  </div>
</template>

<style scoped>
.home-logo {
  width: 100%;
  height: 400px;
  object-fit: cover;
  display: block;
}

.account-introduction-title {
  text-align: center;
  margin-top: 20px;
}

.account-buttons {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20px;
}

.account-buttons button {
  width: 70%;
  font-weight: bold;
  font-size: 18px;
}

.account-button {
  font-weight: bold;
  font-size: 18px;
  padding: 10px 50px;
}

.guest-login-button {
  background-color: #f75549;
  font-weight: bold;
  font-size: 18px;
  padding: 10px 50px;
}

@media screen and (max-width: 768px) {
  .home-logo {
    width: 100%;
    height: 200px;
    object-fit: cover;
    display: block;
  }
}
</style>
