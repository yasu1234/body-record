<template>
  <Header />
  <TabMenu />
  <Toast position="top-center" />
  <div class="setting-container">
    <SettingSideMenu :currentIndex="3" />
    <main>
      <p class="title-line pt-10">パスワード変更</p>
      <div class="password-edit-container">
        <form class="form" @submit.prevent="checkValidate">
          <div class="pt-10">
            <label for="password">現在のパスワード</label>
            <PasswordText
              :password="currentPassword"
              :passwordType="PasswordType.password"
              @update-password="updatePassword"
            />
            <p class="validation-error-message">{{ currentPasswordError }}</p>
          </div>
          <div class="pt-10">
            <label for="password">パスワード</label>
            <PasswordText
              :password="password"
              :passwordType="PasswordType.newPassword"
              @update-password="updatePassword"
            />
            <p class="validation-error-message">{{ passwordError }}</p>
          </div>
          <div class="pt-10">
            <label for="passwordConfirm">パスワード(確認)</label>
            <PasswordText
              :password="passwordConfirm"
              :passwordType="PasswordType.newPasswordConfirm"
              @update-password="updatePassword"
            />
            <p class="validation-error-message">{{ passwordConfirmError }}</p>
          </div>
          <div class="text-center">
            <button class="password-edit-button mt-5">更新</button>
          </div>
        </form>
      </div>
    </main>
  </div>
</template>

<script setup>
import { useField, useForm } from "vee-validate";
import * as yup from "yup";
import Toast from "primevue/toast";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../../js/toast.js";
import { axiosInstance } from "../../../js/axios.js";

import Header from "../../layout/Header.vue";
import PasswordText from "../../atom/PasswordText.vue";
import SettingSideMenu from "../../layout/SettingSideMenu.vue";
import TabMenu from "../../layout/TabMenu.vue";
import { PasswordType } from "../../../js/const.js";

const toast = useToast();
const toastNotifications = new toastService(toast);

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

    const res = await axiosInstance.put(`/api/v1/auth/password`, formData);
    toastNotifications.displayInfo("パスワードを変更しました", "");
  } catch (error) {
    if (error.response == null) {
      toastNotifications.displayError("パスワード変更に失敗しました", "");
      return;
    }

    let errorMessages = "";

    if (error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      } else {
        errorMessages = error.response.data.errors;
      }
    } else if (error.response.status === 401) {
      errorMessages = "ログインしてください";
    }

    toastNotifications.displayError(
      "パスワード変更に失敗しました",
      errorMessages
    );
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

<style scoped>
.password-edit-container {
  width: 500px;
  margin: 0 auto;
  margin-top: 20px;
  padding: 20px;
  background-color: #ffffff;
  border: 1px solid #ccc;
  border-radius: 5px;
}
.password-edit-button {
  font-size: 16px;
  font-weight: bold;
  padding: 10px 50px;
}

@media screen and (max-width: 768px) {
  main {
    flex: 1;
  }
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
