<template>
  <Header />
  <TabMenu />
  <Toast position="top-center" />
  <p class="title_line mt-5">お問合せ</p>
  <div class="contact-container mt-5 pb-8">
    <form class="contact-form" @submit.prevent="contactSubmit">
      <div class="contact-item">
        <label class="contact-require-label"
          >要望や不適切な表現がある場合にはお問合せフォームを入力してください</label
        >
        <textarea name="contact" rows="20" v-model="contact" class="w-full" />
        <div class="mt-2 text-right profile-input-width">
          <p v-if="contact.length > 5000" class="text-red-500">
            5000文字以上入力しています
          </p>
          <p v-else>残り{{ 5000 - contact.length }}文字入力できます</p>
        </div>
        <p>※あくまでもポートフォリオなのでご了承ください</p>
        <p>※問い合わせが完了したら開発者にメールが届くようになっています</p>
      </div>
      <div class="pt-7 text-center">
        <button class="submit-button">送信</button>
      </div>
    </form>
    <router-link :to="'contact-list'" class="contact-link mt-5"
      >問い合わせ一覧はこちら</router-link
    >
  </div>
</template>

<script setup>
import { ref } from "vue";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../../js/toast.js";
import Toast from "primevue/toast";
import { useRouter } from "vue-router";
import { axiosInstance, setupInterceptors } from "../../../js/axios.js";

import Header from "../../layout/Header.vue";
import TabMenu from "../../layout/TabMenu.vue";

const router = useRouter();
setupInterceptors(router);

const contact = ref("");
const toast = useToast();
const toastNotifications = new toastService(toast);

const contactSubmit = async () => {
  try {
    const formData = new FormData();
    formData.append("contact[content]", contact.value);

    const res = await axiosInstance.post(`/api/v1/contacts`, formData);
    toastNotifications.displayError("お問合せを送信しました", "");
    setTimeout(async () => {
      showContactList();
    }, 3000);
  } catch (error) {
    if (error.response == null) {
      toastNotifications.displayError("お問合せ送信に失敗しました", "");
      return;
    }
    let errorMessages = "";
    if (error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      } else {
        errorMessages = error.response.data.errors;
      }
    }
    toastNotifications.displayError(
      "お問合せ送信に失敗しました",
      errorMessages
    );
  }
};

const showContactList = () => {
  router.push({ name: "ContactList" });
};
</script>

<style scoped>
.contact-container {
  display: flex;
  flex-direction: column;
  align-items: center;
}
.contact-form {
  width: 100%;
  box-sizing: border-box;
}
.contact-item {
  padding-top: 40px;
  width: 80%;
  margin: 0 auto;
}
.contact-require-label {
  display: block;
  text-align: left;
}
.submit-button {
  font-size: 16px;
  font-weight: bold;
  padding: 10px 50px;
}
.contact-link {
  background-color: transparent;
  color: #ffa500;
  font-weight: bold;
}
</style>
