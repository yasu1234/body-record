<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import Toast from "primevue/toast";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../const/toast.js";
import FloatLabel from "primevue/floatlabel";
import InputText from "primevue/inputtext";
import Textarea from "primevue/textarea";
import axiosInstance from "../../const/axios.js";

import DropFile from "../atom/DropFile.vue";
import Header from "../layout/Header.vue";
import TabMenu from "../layout/TabMenu.vue";

const router = useRouter();
const toast = useToast();
const toastNotifications = new toastService(toast);

const title = ref("");
const knowledge = ref("");
const files = ref([]);

function onFileChange(event) {
  files.value = [...event];
}

const registerKnowledge = async () => {
  try {
    const formData = new FormData();
    formData.append("knowledge[title]", title.value);
    formData.append("knowledge[content]", knowledge.value);

    for (const file of files.value) {
      formData.append("knowledge[images]", file);
    }

    const res = await axiosInstance.post("/api/v1/knowledges", formData);
    toastNotifications.displayInfo("登録しました", "");
    setTimeout(async () => {
      showKnowledgeDetail(res.data.knowledge);
    }, 3000);
  } catch (error) {
    let errorMessages = "";
    if (error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      }
    }
    toastNotifications.displayError(
      "ノウハウの追加に失敗しました",
      errorMessages
    );
  }
};

const showKnowledgeDetail = (item) => {
  router.push({ name: "KnowledgeDetail", params: { id: item.id } });
};
</script>

<template>
  <Header />
  <TabMenu />
  <Toast position="top-center" />
  <div class="p-7">
    <FloatLabel class="mt-5">
      <InputText v-model="title" class="input-width" />
      <label>タイトル</label>
    </FloatLabel>
    <FloatLabel class="mt-5">
      <Textarea v-model="knowledge" rows="20" class="input-width" />
      <label>詳細</label>
    </FloatLabel>
  </div>
  <div class="p-5">
    <p class="inputTitle">関連画像(5枚まで登録できます)</p>
    <div v-for="i in 5">
      <DropFile @change="onFileChange" :index="i" class="mt-3" />
    </div>
  </div>
  <div class="p-5 text-center">
    <button class="add-knowledge-button" @click="registerKnowledge">
      登録する
    </button>
  </div>
</template>

<style scoped>
.input-width {
  width: 100%;
  padding: 10px;
}
.add-knowledge-button {
  font-size: 16px;
  font-weight: bold;
}
</style>
