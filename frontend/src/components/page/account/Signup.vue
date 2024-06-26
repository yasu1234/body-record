<template>
  <Header />
  <Toast position="top-center" />
  <p class="title-line view-title container-width mt-7">会員登録</p>
  <div class="signup-container container-width pt-5 mt-5">
    <form class="form" @submit.prevent @keydown.enter.prevent>
      <div class="signup-item">
        <label>メールアドレス</label>
        <input id="email" type="email" v-model="email" />
        <p class="validation-error-message">{{ emailError }}</p>
      </div>
      <div class="signup-item">
        <label>パスワード</label>
        <PasswordText
          :password="password"
          :passwordType="PasswordType.password"
          @update-password="updatePassword"
        />
        <p class="validation-error-message">{{ passwordError }}</p>
      </div>
      <div class="signup-item">
        <label>パスワード(確認)</label>
        <PasswordText
          :password="passwordConfirm"
          :passwordType="PasswordType.passwordConfirm"
          @update-password="updatePassword"
        />
        <p class="validation-error-message">{{ passwordConfirmError }}</p>
      </div>
      <div class="signup-item">
        <label>名前</label>
        <input id="name" type="text" v-model="name" />
        <p class="validation-error-message">{{ nameError }}</p>
      </div>
      <div class="text-center mt-5">
        <button class="signup-button" @click="checkValidate">登録</button>
      </div>
    </form>
  </div>
</template>

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
import { PasswordType } from "../../../js/const.js";

const router = useRouter();
const toast = useToast();
const toastNotifications = new toastService(toast);
setupInterceptors(router);

const checkValidate = async () => {
  const result = await validate();
  if (result.valid) {
    signup();
  }
};

const signup = async () => {
  try {
    const res = await axiosInstance.post("/api/v1/auth", {
      email: email.value,
      password: password.value,
      password_confirmation: passwordConfirm.value,
      name: name.value,
    });
    Cookies.set("accessToken", res.headers["access-token"], { expires: 14 });
    Cookies.set("client", res.headers["client"], { expires: 14 });
    Cookies.set("uid", res.headers["uid"], { expires: 14 });

    router.push({ name: "Home" });
  } catch (error) {
    let errorMessages = "";
    if (error.response != null && error.response.status === 422) {
      if (Array.isArray(error.response.data.errors.full_messages)) {
        errorMessages += error.response.data.errors.full_messages.join("\n");
      } else {
        errorMessages = error.response.data.errors.full_messages;
      }
    }
    toastNotifications.displayError("会員登録に失敗しました", errorMessages);
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
  email: yup
    .string()
    .required("この項目は必須です")
    .email("メールアドレスの形式で入力してください"),
  name: yup.string().required("この項目は必須です"),
});

const { validate } = useForm({
  validationSchema: schema,
  initialValues: {
    password: "",
    passwordConfirm: "",
    email: "",
    name: "",
  },
});

const { value: password, errorMessage: passwordError } = useField("password");
const { value: passwordConfirm, errorMessage: passwordConfirmError } =
  useField("passwordConfirm");
const { value: email, errorMessage: emailError } = useField("email");
const { value: name, errorMessage: nameError } = useField("name");

const updatePassword = (inputPassword, passwordType) => {
  if (passwordType === PasswordType.password) {
    password.value = inputPassword;
  } else if (passwordType === PasswordType.passwordConfirm) {
    passwordConfirm.value = inputPassword;
  }
};
</script>

<style scoped>
.signup-container {
  padding: 20px;
  background-color: #ffffff;
  border: 1px solid #ccc;
  border-radius: 5px;
}
.container-width {
  width: 500px;
  margin-left: auto;
  margin-right: auto;
}
.signup-item {
  padding-top: 40px;
  margin: 0 auto;
}
.form input[type="email"],
.form input[type="text"] {
  padding: 10px;
  width: 100%;
  border: 1px solid #ccc;
}
.signup-button {
  font-size: 16px;
  font-weight: bold;
  padding: 10px 50px;
}

@media screen and (max-width: 768px) {
  .signup-container {
    padding: 20px;
    background-color: #ffffff;
    border: 1px solid #ccc;
    border-radius: 5px;
  }

  .container-width {
    width: auto;
    margin-left: 20px;
    margin-right: 20px;
  }
}
</style>
