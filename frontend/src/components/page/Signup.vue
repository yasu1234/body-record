<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import Cookies from "js-cookie";
import axios from "axios";
import { useField, useForm } from "vee-validate";
import * as yup from "yup";

import Header from "../layout/Header.vue";
import ErrorMessage from "../atom/ErrorMessage.vue";
import PasswordText from "../atom/PasswordText.vue";
import { PasswordType } from "../../const/const.js";

const router = useRouter();

const errorMessage = ref("");

defineProps({
  msg: String,
});

const checkValidate = async () => {
  const result = await validate();
  if (result.valid) {
    signup();
  }
};

const signup = async () => {
  try {
    const res = await axios.post(
      import.meta.env.VITE_APP_API_BASE + "/api/v1/auth",
      {
        email: email.value,
        password: password.value,
        password_confirmation: passwordConfirm.value,
        name: name.value,
      }
    );
    Cookies.set("accessToken", res.headers["access-token"]);
    Cookies.set("client", res.headers["client"]);
    Cookies.set("uid", res.headers["uid"]);

    router.push({ name: "Home" });
  } catch (error) {
    let errorMessages = "会員登録に失敗しました\n";
    if (error.response.status === 422) {
      if (Array.isArray(error.response.data.errors.full_messages)) {
        errorMessages += error.response.data.errors.full_messages.join("\n");
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

<template>
  <Header />
  <h1 class="signup-title">会員登録</h1>
  <ErrorMessage :errorMessage="errorMessage" />
  <div class="signup-container">
    <form class="form" @submit.prevent="checkValidate">
      <div class="item">
        <label>メールアドレス</label>
        <input id="email" type="email" v-model="email" />
        <p class="validation-error-message">{{ emailError }}</p>
      </div>
      <div class="item">
        <label for="password">パスワード</label>
        <PasswordText
          :password="password"
          :passwordType="PasswordType.password"
          @updatePassword="updatePassword"
        />
        <p class="validation-error-message">{{ passwordError }}</p>
      </div>
      <div class="item">
        <label for="passwordConfirm">パスワード(確認)</label>
        <PasswordText
          :password="passwordConfirm"
          :passwordType="PasswordType.passwordConfirm"
          @updatePassword="updatePassword"
        />
        <p class="validation-error-message">{{ passwordConfirmError }}</p>
      </div>
      <div class="item">
        <label for="name">名前</label>
        <input id="name" type="text" v-model="name" />
        <p class="validation-error-message">{{ nameError }}</p>
      </div>
      <div class="signUpTitle">
        <button class="signup-button">登録</button>
      </div>
    </form>
  </div>
</template>

<style scoped>
.signup-container {
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

.signup-title {
  padding-top: 40px;
  text-align: center;
}

.item {
  padding-top: 40px;
  margin: 0 auto;
}

.form input[type="email"],
.form input[type="text"] {
  padding: 10px;
  width: 100%;
}

.signup-button {
  font-size: 16px;
  font-weight: bold;
  padding: 10px 50px;
}

@media screen and (max-width: 768px) {
  .signup-container {
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
