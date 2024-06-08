<script setup>
import { ref, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../const/toast.js";
import Toast from "primevue/toast";
import Button from "primevue/button";
import { axiosInstance, setupInterceptors } from "../../const/axios.js";

import DropFile from "../atom/DropFile.vue";
import Header from "../layout/Header.vue";

const route = useRoute();
const router = useRouter();
const toast = useToast();
const toastNotifications = new toastService(toast);
setupInterceptors(router);

const title = ref("");
const knowledge = ref("");
const files = ref([]);
const imageUrls = ref([]);
const knowledgeId = ref(null);

onMounted(() => {
  getDetail();
});

function onFileChange(event) {
  files.value = [...event];
}

const deleteImage = async (item) => {
  try {
    const res = await axiosInstance.delete("/api/v1/knowledges/image", {
      params: {
        id: knowledgeId.value,
        image_id: item.id,
      },
    });
    console.log({ res });
  } catch (error) {
    let errorMessages = "画像の削除に失敗しました\n";
    if (error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      }
    }
    errorMessage.value = errorMessages;
  }
};

const getDetail = async () => {
  const id = route.params.id;
  try {
    const res = await axiosInstance.get(`/api/v1/knowledges/${id}`);
    knowledgeId.value = res.data.knowledge.id;
    title.value = res.data.knowledge.title;
    knowledge.value = res.data.knowledge.content;
    imageUrls.value = res.data.imageUrls;
  } catch (error) {}
};

const edit = async () => {
  try {
    const formData = new FormData();
    formData.append("knowledge[title]", title.value);
    formData.append("knowledge[content]", knowledge.value);

    for (const file of files.value) {
      formData.append("images", file);
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
    let errorMessage = "";
    if (error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessage += error.response.data.errors.join("\n");
      }
    }

    toastNotifications.displayError(
      "ノウハウの編集に失敗しました",
      errorMessage
    );
  }
};

const showKnowledgeDetail = (item) => {
  router.push({ name: "KnowledgeDetail", params: { id: item.id } });
};
</script>

<template>
  <Header />
  <Toast position="top-center" />
  <div class="p-7">
    <label class="itemLabel">タイトル</label>
    <input id="title" type="text" v-model="title" />
    <textarea name="knowledge" rows="20" v-model="knowledge"></textarea>
  </div>
  <div class="thumbnail-container">
    <div class="thumbnail" v-for="item in imageUrls">
      <div class="thumbnail-image">
        <img :src="item.url" alt="" />
      </div>
      <div class="thumbnail-actions">
        <Button
          label=""
          icon="pi pi-trash"
          class="delete-button"
          @click="deleteImage(item)"
        />
      </div>
    </div>
  </div>
  <div class="relationImages">
    <p class="inputTitle">関連画像</p>
    <DropFile @change="onFileChange" />
  </div>
  <div class="relationImages">
    <button class="edit-knowledge-button" @click="edit">編集する</button>
  </div>
</template>

<style scoped>
input[type="text"] {
  width: 100%;
  padding: 12px 12px;
  margin: 8px 0;
  box-sizing: border-box;
  border: 1px solid #ccc;
  border-radius: 4px;
}
.time-list {
  display: flex;
  justify-content: space-between;
  padding-left: 30px;
  padding-right: 30px;
}
.time-list .item {
  width: 50%;
  margin: 0;
  padding: 10px;
  box-sizing: border-box;
}
.time-list .item .inputTitle {
  margin: 5px 0 0;
  padding: 0;
  font-size: 16px;
}
.relationImages {
  padding: 20px;
}
.edit-knowledge-button {
  font-size: 16px;
  font-weight: bold;
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
  height: 200px;
  margin-right: 15px;
  margin-bottom: 15px;
  padding-left: 20px;
}
.thumbnail img {
  height: 100%;
}
.thumbnail-image {
  height: 100%;
}
.thumbnail-image img {
  height: 100%;
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
</style>
