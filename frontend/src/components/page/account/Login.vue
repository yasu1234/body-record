<script setup>
import { useRouter } from "vue-router";
import Cookies from "js-cookie";
import { useField, useForm } from "vee-validate";
import * as yup from "yup";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../../js/toast.js";
import Toast from "primevue/toast";
import { axiosInstance, setupInterceptors } from "../../../js/axios.js";

import Header from "../../layout/Header.vue";
import PasswordText from "../../atom/PasswordText.vue";

const router = useRouter();
const toast = useToast();
const toastNotifications = new toastService(toast);
setupInterceptors(router);

const handleSubmit = async () => {
  const result = await validate();
  if (result.valid) {
    login();
  }
};

const login = async () => {
  try {
    const res = await axiosInstance.post("/api/v1/auth/sign_in",
      {
        email: email.value,
        password: password.value,
      }
    );
    Cookies.set("accessToken", res.headers["access-token"]);
    Cookies.set("client", res.headers["client"]);
    Cookies.set("uid", res.headers["uid"]);

    router.push({ name: "Home" });
  } catch (error) {
    let errorMessages = "";
    if (error.response.status === 401) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      }
    }
    toastNotifications.displayError("ログインに失敗しました", errorMessages)
  }
};

const schema = yup.object({
  password: yup
    .string()
    .required("この項目は必須です")
    .min(6, "6文字以上で入力してください")
    .max(128, "128文字以下で入力してください"),
  email: yup
    .string()
    .required("この項目は必須です")
    .email("メールアドレスの形式で入力してください"),
});

const { validate } = useForm({ validationSchema: schema });
const { value: password, errorMessage: passwordError } = useField(
  "password",
  ""
);
const { value: email, errorMessage: emailError } = useField("email", "");

const updatePassword = (inputPassword, passwordType) => {
  password.value = inputPassword;
};
</script>

<template>
  <Header />
  <Toast position="top-center" />
  <h1 class="view-title mt-7">ログイン</h1>
  <div class="login-container">
    <form class="form" @submit.prevent="handleSubmit">
      <div class="item">
        <label>メールアドレス</label>
        <input id="email" type="email" v-model="email" />
        <p class="validation-error-message">{{ emailError }}</p>
      </div>
      <div class="item">
        <label>パスワード</label>
        <PasswordText :password="password" @updatePassword="updatePassword" />
        <p class="validation-error-message">{{ passwordError }}</p>
      </div>
      <div class="login-button-container">
        <button class="login-button">ログイン</button>
      </div>
    </form>
  </div>
</template>

<style scoped>
.login-container {
  width: 500px;
  margin: 0 auto;
  padding: 20px;
  background-color: #ffffff;
  border: 1px solid #ccc;
  border-radius: 5px;
}

.form {
  width: 100%;
  margin: 0 auto;
  box-sizing: border-box;
}

.item {
  padding-top: 40px;
  margin: 0 auto;
}

.form input[type="email"] {
  padding: 10px;
  width: 100%;
}

.login-button-container {
  padding-top: 40px;
  text-align: center;
}

.login-button {
  font-size: 16px;
  font-weight: bold;
  padding: 10px 50px;
}

@media screen and (max-width: 768px) {
  .login-container {
    width: auto;
    margin-left: 20px;
    margin-right: 20px;
    padding: 20px;
    background-color: #ffffff;
    border: 1px solid #ccc;
    border-radius: 5px;
  }
}
</style>