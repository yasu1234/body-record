<template>
  <div class="login-introduction-container p-2.5">
    <p class="font-bold text-lg">ログインしてください</p>
    <div class="my-5">
      <button
        class="account-introducton-button"
        @click="showAccountIntroduction"
      >
        会員登録・ログイン
      </button>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from "vue-router";
import Cookies from "js-cookie";

const router = useRouter();

const showAccountIntroduction = () => {
  console.log(router.currentRoute.value.fullPath);
  router.push({ name: "AccountInteroduction" });
};
</script>

<style scoped>
.login-introduction-container {
  background: #ffe6c3;
  border: 1px solid brown;
  text-align: center;
}
.empty-container p {
  color: #704305;
}
.account-introducton-button {
  padding: 10px 50px;
  font-weight: bold;
}
</style>
