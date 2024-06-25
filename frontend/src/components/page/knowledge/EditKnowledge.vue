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
    <div class="markdown-info">
      マークダウンを一部使用できます。詳しくは<a
        href="https://kumaapp.amebaownd.com/posts/54283163"
        target="_blank"
        rel="noopener noreferrer"
        class="info-link"
        >こちら</a
      >をご覧ください。<br>
      特に複数行の改行は使うことが多いと思うので必ずご確認ください
    </div>
  </div>
  <div v-if="imageUrls !== null && imageUrls.length !== 0">
    <p class="mt-5 ml-5">登録済みの画像</p>
    <div class="thumbnail-container">
      <div class="thumbnail" v-for="item in imageUrls">
        <div class="thumbnail-image">
          <img :src="item.url" alt="" />
        </div>
        <div class="thumbnail-actions">
          <Button
            label=""
            icon="pi pi-trash"
            v-tooltip="{ value: '画像削除' }"
            class="delete-button"
            @click="deleteImage(item)"
          />
        </div>
      </div>
    </div>
  </div>
  <div class="p-5">
    <p>関連画像(5枚まで登録できます)</p>
    <div class="file-input-container">
      <div v-for="i in 5">
        <DropFile @change="onFileChange" :index="i" class="mt-3" />
      </div>
    </div>
  </div>
  <div class="p-10 text-center">
    <button class="edit-knowledge-button" @click="edit">編集する</button>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../../js/toast.js";
import Toast from "primevue/toast";
import Button from "primevue/button";
import FloatLabel from "primevue/floatlabel";
import InputText from "primevue/inputtext";
import { axiosInstance, setupInterceptors } from "../../../js/axios.js";

import DropFile from "../../atom/DropFile.vue";
import Header from "../../layout/Header.vue";
import TabMenu from "../../layout/TabMenu.vue";
import KnowledgeContentInput from "../../layout/KnowledgeContentInput.vue";

const route = useRoute();
const router = useRouter();
const toast = useToast();
const toastNotifications = new toastService(toast);
setupInterceptors(router);

const title = ref("");
const knowledge = ref("");
const files = ref([...Array(5)]);
const imageUrls = ref([]);
const knowledgeId = ref(null);

onMounted(() => {
  getDetail();
});

const deleteImage = async (item) => {
  try {
    const res = await axiosInstance.delete("/api/v1/knowledge_images", {
      params: {
        id: knowledgeId.value,
        image_id: item.id,
      },
    });
    imageUrls.value = res.data.image_urls;
  } catch (error) {
    if (error.response == null) {
      toastNotifications.displayError("画像の削除に失敗しました", "");
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

    toastNotifications.displayError("画像の削除に失敗しました", errorMessages);
  }
};

const getDetail = async () => {
  const id = route.params.id;
  try {
    const res = await axiosInstance.get(`/api/v1/knowledges/${id}`);
    knowledgeId.value = res.data.knowledge.id;
    title.value = res.data.knowledge.title;
    knowledge.value = res.data.knowledge.content;
    imageUrls.value = res.data.knowledge.image_urls;
  } catch (error) {
    let errorMessage = "";
    if (error.response != null && error.response.status === 401) {
      errorMessage = "ログインしてください";
    }
    toastNotifications.displayError("登録データの取得に失敗しました", errorMessage);
  }
};

const edit = async () => {
  try {
    const formData = new FormData();
    formData.append("knowledge[title]", title.value);
    formData.append("knowledge[content]", knowledge.value);

    for (const file of files.value) {
      if (file != null) {
        formData.append("knowledge[images][]", file);
      }
    }

    const res = await axiosInstance.patch(
      `/api/v1/knowledges/${knowledgeId.value}`,
      formData,
      {
        headers: {
          "Content-Type": "multipart/form-data",
        },
      }
    );

    toastNotifications.displayInfo("編集しました", "");
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
      "記事の編集に失敗しました",
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

<style scoped>
.input-width {
  width: 100%;
  padding: 10px;
}
.edit-knowledge-button {
  font-size: 16px;
  font-weight: bold;
  padding: 10px 50px;
}
.thumbnail-container {
  display: flex;
  flex-wrap: wrap;
  justify-content: flex-start;
  padding: 20px;
}
.thumbnail {
  position: relative;
  display: inline-block;
  margin-right: 15px;
  margin-bottom: 15px;
  padding-left: 20px;
}
.thumbnail-image {
  height: 200px;
  width: 200px;
}
.thumbnail-image img {
  height: 200px;
  width: 200px;
}
.thumbnail-actions {
  position: absolute;
  top: 5px;
  right: 5px;
}
.delete-button {
  background-color: rgba(255, 255, 255, 0.7);
  border: none;
  color: #000;
  padding: 5px 10px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 12px;
  border-radius: 4px;
  cursor: pointer;
  border-radius: 50%;
}
.markdown-info {
  font-size: 14px;
  color: #333;
}
.info-link {
  color: #ffa500;
  text-decoration: underline;
  cursor: pointer;
}
.info-link:hover {
  color: #ffa500;
}
</style>
