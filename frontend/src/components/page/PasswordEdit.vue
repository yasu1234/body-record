<script setup>
import axios from "axios";
import { ref } from "vue";
import Cookies from "js-cookie";
import { useField, useForm } from "vee-validate";
import * as yup from "yup";

import Header from "../layout/Header.vue";
import ErrorMessage from "../atom/ErrorMessage.vue";
import PasswordText from "../atom/PasswordText.vue";
import { PasswordType } from "../../const/const.js";

const errorMessage = ref("");

const checkValidate = async () => {
  const result = await validate();
  if (result.valid) {
    passwordEdit();
  }
};

const passwordEdit = async () => {
  try {
    const formData = new FormData();
    formData.append("current_password", currentPassword.value);
    formData.append("password", password.value);
    formData.append("password_confirmation", passwordConfirm.value);

    const res = await axios.put(
      import.meta.env.VITE_APP_API_BASE + `/api/v1/auth/password`,
      formData,
      {
        headers: {
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
      }
    );
    console.log({ res });
  } catch (error) {
    errorMessage.value = "";
    let errorMessages = "パスワード変更に失敗しました\n";
    if (error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      }
    }
    errorMessage.value = errorMessages;
  }
};

const schema = yup.object({
  password: yup
    .string()
    .required("この項目は必須です")
    .min(6, "6文字以上で入力してください")
    .max(128, "128文字以下で入力してください"),
  passwordConfirm: yup
    .string()
    .required("この項目は必須です")
    .min(6, "6文字以上で入力してください")
    .max(128, "128文字以下で入力してください"),
  currentPassword: yup
    .string()
    .required("この項目は必須です")
    .min(6, "6文字以上で入力してください")
    .max(128, "128文字以下で入力してください"),
});

const { validate } = useForm({
  validationSchema: schema,
  initialValues: {
    password: "",
    passwordConfirm: "",
    currentPassword: "",
  },
});

const { value: password, errorMessage: passwordError } = useField("password");
const { value: passwordConfirm, errorMessage: passwordConfirmError } =
  useField("passwordConfirm");
const { value: currentPassword, errorMessage: currentPasswordError } =
  useField("currentPassword");

const updatePassword = (inputPassword, passwordType) => {
  if (passwordType === PasswordType.password) {
    currentPassword.value = inputPassword;
  } else if (passwordType === PasswordType.newPassword) {
    password.value = inputPassword;
  } else if (passwordType === PasswordType.newPasswordConfirm) {
    passwordConfirm.value = inputPassword;
  }
};
</script>

<template>
  <Header />
  <ErrorMessage :errorMessage="errorMessage" />
  <h1 class="signUpTitle">パスワード変更</h1>
  <div class="password-edit-container">
    <form class="form" @submit.prevent="checkValidate">
      <div class="item">
        <label for="password">現在のパスワード</label>
        <PasswordText
          :password="currentPassword"
          :passwordType="PasswordType.password"
          @updatePassword="updatePassword"
        />
        <p class="validation-error-message">{{ currentPasswordError }}</p>
      </div>
      <div class="item">
        <label for="password">パスワード</label>
        <PasswordText
          :password="password"
          :passwordType="PasswordType.newPassword"
          @updatePassword="updatePassword"
        />
        <p class="validation-error-message">{{ passwordError }}</p>
      </div>
      <div class="item">
        <label for="passwordConfirm">パスワード(確認)</label>
        <PasswordText
          :password="passwordConfirm"
          :passwordType="PasswordType.newPasswordConfirm"
          @updatePassword="updatePassword"
        />
        <p class="validation-error-message">{{ passwordConfirmError }}</p>
      </div>
      <div class="signUpTitle">
        <button class="password-edit-button">更新</button>
      </div>
    </form>
  </div>
</template>

<style scoped>
.password-edit-container {
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

.signUpTitle {
  padding-top: 40px;
  text-align: center;
}

.item {
  padding-top: 40px;
  margin: 0 auto;
}

.password-edit-button {
  font-size: 16px;
  font-weight: bold;
  padding: 10px 50px;
}

@media screen and (max-width: 768px) {
  .password-edit-container {
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