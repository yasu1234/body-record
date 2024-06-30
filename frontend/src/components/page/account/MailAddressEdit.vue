<template>
  <Header />
  <TabMenu />
  <Toast position="top-center" />
  <div class="setting-container">
    <SettingSideMenu :currentIndex="2" />
    <main>
      <p class="title_line pt-10">メールアドレス変更</p>
      <div class="mailaddress-edit-container">
        <form class="form" @submit.prevent="checkValidate">
          <div class="pt-10">
            <FloatLabel>
              <InputText
                v-model="newMailAddres"
                class="email-edit-input h-10 p-2.5"
              />
              <label>変更後のメールアドレス</label>
            </FloatLabel>
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

<script setup>
import Cookies from "js-cookie";
import { useField, useForm } from "vee-validate";
import * as yup from "yup";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../../js/toast.js";
import Toast from "primevue/toast";
import FloatLabel from "primevue/floatlabel";
import InputText from "primevue/inputtext";
import { axiosInstance } from "../../../js/axios.js";

import Header from "../../layout/Header.vue";
import SettingSideMenu from "../../layout/SettingSideMenu.vue";
import TabMenu from "../../layout/TabMenu.vue";

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

    const res = await axiosInstance.put(`/api/v1/auth`, formData);

    Cookies.set("accessToken", res.headers["access-token"]);
    Cookies.set("client", res.headers["client"]);
    Cookies.set("uid", res.headers["uid"]);

    toastNotifications.displayInfo("メールアドレスを変更しました", "");
  } catch (error) {
    if (error.response == null) {
      toastNotifications.displayError("メールアドレス変更に失敗しました", "");
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
      "メールアドレス変更に失敗しました",
      errorMessages
    );
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

<style scoped>
.mailaddress-edit-container {
  width: 500px;
  margin: 0 auto;
  padding: 20px;
  margin-top: 20px;
  background-color: #ffffff;
  border: 1px solid #ccc;
  border-radius: 5px;
}
.mailaddress-edit-content-center {
  padding-top: 40px;
  text-align: center;
}
.email-edit-input {
  width: 100%;
  border: #ccc 1px solid;
}
.mailaddress-edit-button {
  font-size: 16px;
  font-weight: bold;
  padding: 10px 50px;
}

@media screen and (max-width: 768px) {
  main {
    flex: 1;
  }
  .mailaddress-edit-container {
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
