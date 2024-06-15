<script setup>
import { ref, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import { axiosInstance, setupInterceptors } from "../../../js/axios.js";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../../js/toast.js";

const toast = useToast();
const toastNotifications = new toastService(toast);

import Header from "../../layout/Header.vue";
import TabMenu from "../../layout/TabMenu.vue";

const route = useRoute();
const router = useRouter();
setupInterceptors(router);

const contact = ref(null);

onMounted(() => {
  getDetail();
});

const getDetail = async () => {
  const id = route.params.id;
  try {
    const res = await axiosInstance.get(`/api/v1/contacts/${id}`);
    contact.value = res.data.contact;
  } catch (error) {
    toastNotifications.displayError("問い合わせ内容の取得に失敗しました", "")
  }
};

const statusChange = async (isComplete) => {
  try {
    const formData = new FormData();
    if (isComplete) {
      formData.append("status", null);
    } else {
      formData.append("status", 1);
    }

    const res = await axiosInstance.put(
      `/api/v1/contacts/${contact.value.id}`,
      formData
    );
    contact.value = res.data.contact;
  } catch (error) {
    let errorMessages = "";
    if (error.response != null && error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      } else {
        errorMessages = error.response.data.errors;
      }
    }
    toastNotifications.displayError("対応状況更新に失敗しました", errorMessages);
  }
};
</script>

<template>
  <Toast position="top-center" />
  <Header />
  <TabMenu />
  <div v-if="contact !== null">
    <div class="p-7">
      <p id="title" class="knowledge-title" type="text">
        {{ contact.content }}
      </p>
    </div>
    <div class="p-5">
      <button
        class="status-edit-button"
        v-if="contact.status === 1"
        @click="statusChange(true)"
      >
        対応中に戻す
      </button>
      <button class="status-edit-button" v-else @click="statusChange(false)">
        対応済にする
      </button>
    </div>
  </div>
</template>

<style scoped>
.knowledge-title {
  font-weight: bold;
  font-size: 22px;
}
.status-edit-button {
  font-size: 16px;
  font-weight: bold;
}
</style>