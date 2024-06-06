<script setup>
import axios from "axios";
import { ref } from "vue";
import Cookies from "js-cookie";
import { useField, useForm } from "vee-validate";
import * as yup from "yup";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../const/toast.js";
import Toast from "primevue/toast";

import Header from "../layout/Header.vue";
import SettingSideMenu from "../layout/SettingSideMenu.vue";
import TabMenu from "../layout/TabMenu.vue";

const toast = useToast();
const toastNotifications = new toastService(toast);

const checkValidate = async () => {
  const result = await validate();
  if (result.valid) {
    mailAddressEdit();
  }
};

const mailAddressEdit = async () => {
  try {
    const formData = new FormData();
    formData.append("email", newMailAddres.value);

    const res = await axios.put(
      import.meta.env.VITE_APP_API_BASE + `/api/v1/auth`,
      formData,
      {
        headers: {
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
      }
    );

    Cookies.set("accessToken", res.headers["access-token"]);
    Cookies.set("client", res.headers["client"]);
    Cookies.set("uid", res.headers["uid"]);

    toastNotifications.displayInfo("メールアドレスを変更しました", "");
  } catch (error) {
    let errorMessages = "";
    if (error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      }
    }
    toastNotifications.displayError("メールアドレス変更に失敗しました", errorMessages);
  }
};

const schema = yup.object({
  newMailAddres: yup
    .string()
    .required("この項目は必須です")
    .email("メールアドレスの形式で入力してください"),
});

const { validate } = useForm({
  validationSchema: schema,
  initialValues: {
    newMailAddres: "",
  },
});

const { value: newMailAddres, errorMessage: emailError } =
  useField("newMailAddres");
</script>

<template>
  <Header />
  <TabMenu />
  <Toast position="top-center" />
  <div class="setting-container">
    <SettingSideMenu :currentIndex="2" />
    <main>
      <h1 class="view-title pt-10">メールアドレス変更</h1>
      <div class="mailaddress-edit-container">
        <form class="form" @submit.prevent="checkValidate">
          <div class="form-item">
            <label for="email">変更後のメールアドレス</label>
            <input id="email" type="email" v-model="newMailAddres" />
            <p class="validation-error-message">{{ emailError }}</p>
          </div>
          <div class="mailaddress-edit-content-center">
            <button class="mailaddress-edit-button">更新</button>
          </div>
        </form>
      </div>
    </main>
  </div>
</template>

<style scoped>
.mailaddress-edit-container {
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

.mailaddress-edit-content-center {
  padding-top: 40px;
  text-align: center;
}

.form-item {
  padding-top: 40px;
  margin: 0 auto;
}

.form input[type="email"] {
  padding: 10px;
  width: 100%;
}

.mailaddress-edit-button {
  font-size: 16px;
  font-weight: bold;
  padding: 10px 50px;
}
</style>
