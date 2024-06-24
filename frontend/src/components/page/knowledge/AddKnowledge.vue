<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import Toast from "primevue/toast";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../../js/toast.js";
import FloatLabel from "primevue/floatlabel";
import InputText from "primevue/inputtext";
import { axiosInstance } from "../../../js/axios.js";

import DropFile from "../../atom/DropFile.vue";
import Header from "../../layout/Header.vue";
import TabMenu from "../../layout/TabMenu.vue";
import KnowledgeContentInput from "../../layout/KnowledgeContentInput.vue";

const router = useRouter();
const toast = useToast();
const toastNotifications = new toastService(toast);

const title = ref("");
const knowledge = ref("");
const files = ref([...Array(5)]);

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
    if (error.response == null) {
      toastNotifications.displayError("記事の編集に失敗しました", "");
      return;
    }

    let errorMessage = "";

    if (error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessage += error.response.data.errors.join("\n");
      } else {
        errorMessage = error.response.data.errors;
      }
    } else if (error.response.status === 401) {
      errorMessage = "ログインしてください";
    }

    toastNotifications.displayError(
      "記事の追加に失敗しました",
      errorMessage
    );
  }
};

const onFileChange = (event, index) => {
  files.value[index - 1] = event;
};

const contentEdit = (editContent) => {
  knowledge.value = editContent;
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
    <div class="mt=2.5">
      <KnowledgeContentInput
        :knowledgeContent="knowledge"
        @content-edit="contentEdit"
      />
    </div>
  </div>
  <div class="p-5">
    <h2>関連画像(5枚まで登録できます)</h2>
    <div class="file-input-container">
      <div v-for="i in 5">
        <DropFile @change="onFileChange" :index="i" class="mt-3" />
      </div>
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
  padding: 10px 50px;
}
</style>
