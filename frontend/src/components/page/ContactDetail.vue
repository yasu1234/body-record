<script setup>
import { ref, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import axiosInstance from "../../const/axios.js";

import Header from "../layout/Header.vue";

const route = useRoute();
const router = useRouter();

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
    if (error.response.status === 404) {
      showNotFound();
    }
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
    if (error.response.status === 404) {
      showNotFound();
    }
  }
};

const showNotFound = () => {
  router.push({ name: "NotFound" });
};
</script>

<template>
  <Header />
  <div v-if="contact !== null">
    <div class="p-7">
      <p id="title" class="knowledge-title" type="text">
        {{ contact.content }}
      </p>
    </div>
    <div class="relationImages">
      <button
        class="editButton"
        v-if="contact.status === 1"
        @click="statusChange(true)"
      >
        対応中に戻す
      </button>
      <button class="editButton" v-else @click="statusChange(false)">
        対応済にする
      </button>
    </div>
  </div>
</template>

<style scoped>
.wrap {
  display: grid;
  grid-template-columns: 4fr 1fr;
}
.side_content {
  position: sticky;
  top: 100px;
}

.booknmark-button {
  padding: 0;
  background: transparent;
  border: 1px solid #ccc;
  border-radius: 50%;
}
.booknmark-image {
  width: 40px;
  height: 40px;
}
input[type="text"] {
  width: 100%;
  padding: 12px 12px;
  margin: 8px 0;
  box-sizing: border-box;
  border: 1px solid #ccc;
  border-radius: 4px;
}
.knowledge-title {
  font-weight: bold;
  font-size: 22px;
}
.knowledge-content {
  font-size: 22px;
  padding-top: 20px;
}
.relationImages {
  padding: 20px;
}
.editButton {
  background: #ffa500;
  color: white;
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
.comment-container {
  margin-top: 20px;
  margin-left: 20px;
}
.comment-container-title-area {
  border-bottom: 1px solid rgba(6, 6, 6, 0.17);
}

.comment-textarea {
  width: 100%;
  margin-top: 20px;
}

.comment-container-title {
  text-align: left;
}
</style>
