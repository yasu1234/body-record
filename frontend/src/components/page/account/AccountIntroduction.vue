<template>
  <Toast position="top-center" />
  <img
    src="../../../assets/image/home_image.jpg"
    alt="Logo"
    class="home-logo"
  />
  <p class="introduction-title mt-5">In-body.comへようこそ！</p>
  <div class="account-buttons mt-5">
    <button class="account-button" @click="showSignup">会員登録</button>
    <button class="account-button" @click="showLogin">ログイン</button>
    <button class="guest-login-button" @click="guestLogin">
      ゲストログイン
    </button>
  </div>
</template>

<script setup>
import { useRouter } from "vue-router";
import Cookies from "js-cookie";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../../js/toast.js";
import Toast from "primevue/toast";
import { axiosInstance } from "../../../js/axios.js";

const router = useRouter();
const toast = useToast();
const toastNotifications = new toastService(toast);

const showSignup = () => {
  router.push({ name: "Signup" });
};

const showLogin = () => {
  router.push({ name: "Login" });
};

const guestLogin = async () => {
  try {
    const res = await axiosInstance.post("/api/v1/users/guest_sign_in");
    Cookies.set("accessToken", res.headers["access-token"], { expires: 14 });
    Cookies.set("client", res.headers["client"], { expires: 14 });
    Cookies.set("uid", res.headers["uid"], { expires: 14 });

    if (
      Cookies.get("loginRoutePath") != null &&
      !Cookies.get("loginRoutePath").includes("login") &&
      !Cookies.get("loginRoutePath").includes("accountInteroduction") &&
      !Cookies.get("loginRoutePath").includes("signup")
    ) {
      router.push({ path: Cookies.get("loginRoutePath") });
      Cookies.remove("loginRoutePath");
    } else {
      router.push({ name: "Home" });
    }
  } catch (error) {
    let errorMessages = "";
    if (error.response != null && error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      } else {
        errorMessages = error.response.data.errors;
      }
    }
    toastNotifications.displayError(
      "ゲストログインに失敗しました",
      errorMessages
    );
  }
};
</script>

<style scoped>
.home-logo {
  width: 100%;
  height: 400px;
  display: block;
}
.introduction-title {
  text-align: center;
  font-weight: bold;
  font-size: 30px;
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
    display: block;
  }
}
</style>
