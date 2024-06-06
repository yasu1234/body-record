<script setup>
import { ref, onMounted, computed } from "vue";
import axios from "axios";
import { useRoute, useRouter } from "vue-router";
import Cookies from "js-cookie";
import MarkdownIt from "markdown-it";
import Toast from "primevue/toast";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../const/toast.js";

import Header from "../layout/Header.vue";
import Comments from "../layout/Comments.vue";
import CommentInput from "../layout/CommentInput.vue";
import TabMenu from "../layout/TabMenu.vue";
import Author from "../layout/Author.vue";
import RelationImage from "../layout/RelationImage.vue";

const route = useRoute();
const router = useRouter();
const toast = useToast();
const toastNotifications = new toastService(toast);

const date = ref("");
const memo = ref("");
const imageUrls = ref([]);
const recordId = ref(null);
const recordUserId = ref(0);
const isMyRecord = ref(false);
const isSupport = ref(false);
const comments = ref([]);
const author = ref(null);
const record = ref(null);

const md = new MarkdownIt();

const renderedMarkdown = computed(() => {
  if (memo.value !== null && memo.value !== "") {
    return md.render(memo.value);
  }
  return "";
});

onMounted(() => {
  getDetail();
  getComments();
});

const getDetail = async () => {
  const id = route.params.id;
  try {
    const res = await axios.get(
      import.meta.env.VITE_APP_API_BASE + `/api/v1/records/${id}`,
      {
        headers: {
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
      }
    );
    recordId.value = res.data.record.id;
    record.value = res.data;
    date.value = res.data.record.formatted_date;
    memo.value = res.data.record.memo;
    isMyRecord.value = res.data.record.isMyRecord;
    imageUrls.value = res.data.record.image_urls;
    recordUserId.value = res.data.record.user_id;
    author.value = res.data.record.user;
  } catch (error) {
    if (error.response.status === 404) {
      showNotFound();
    }
  }
};

const getComments = async () => {
  try {
    const res = await axios.get(
      import.meta.env.VITE_APP_API_BASE + `/api/v1/comments/record`,
      {
        headers: {
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
        params: {
          record_id: route.params.id,
        },
      }
    );
    comments.value = res.data.comments;
  } catch (error) {
    if (error.response.status === 404) {
      showNotFound();
    }
  }
};

const deleteRecord = async () => {
  const id = recordId.value;
  try {
    const res = await axios.delete(
      import.meta.env.VITE_APP_API_BASE + `/api/v1/records/${id}`,
      {
        headers: {
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
      }
    );
    toastNotifications.displayInfo("記録を削除しました", "");
    setTimeout(async () => {
      router.back();
    }, 3000);
  } catch (error) {
    if (error.response.status === 404) {
      showNotFound();
    } else {
      let errorMessages = "";
      if (error.response.status === 422) {
        if (Array.isArray(error.response.data.errors)) {
          errorMessages += error.response.data.errors.join("\n");
        }
      }
      toastNotifications.displayError("記録削除に失敗しました", errorMessages);
    }
  }
};

const supportOn = async () => {
  try {
    const formData = new FormData();
    formData.append("id", recordUserId.value);

    const res = await axios.post(
      import.meta.env.VITE_APP_API_BASE + `/api/v1/supports`,
      formData,
      {
        headers: {
          "Content-Type": "multipart/form-data",
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
      }
    );
    isSupport.value = res.data.isSupport;
  } catch (error) {
    if (error.response.status === 404) {
      showNotFound();
    } else {
      let errorMessages = "";
      if (error.response.status === 422) {
        if (Array.isArray(error.response.data.errors)) {
          errorMessages += error.response.data.errors.join("\n");
        } else {
          errorMessages += error.response.data.errors;
        }
      }
      toastNotifications.displayError("応援に失敗しました", errorMessages);
    }
  }
};

const supportOff = async () => {
  try {
    const res = await axios.delete(
      import.meta.env.VITE_APP_API_BASE +
        `/api/v1/supports/${recordUserId.value}`,
      {
        headers: {
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
      }
    );
    isSupport.value = res.data.isSupport;
  } catch (error) {
    if (error.response.status === 404) {
      showNotFound();
    } else {
      let errorMessages = "";
      if (error.response.status === 422) {
        if (Array.isArray(error.response.data.errors)) {
          errorMessages += error.response.data.errors.join("\n");
        } else {
          errorMessages += error.response.data.errors;
        }
      }
      toastNotifications.displayError("応援解除に失敗しました", errorMessages);
    }
  }
};

function supportClick(isSupport) {
  if (isSupport === true) {
    supportOff();
  } else {
    supportOn();
  }
}

const addComment = async (comment) => {
  try {
    const formData = new FormData();
    formData.append("record_id", recordId.value);
    formData.append("comment", comment);

    const res = await axios.post(
      import.meta.env.VITE_APP_API_BASE + `/api/v1/comments/record`,
      formData,
      {
        headers: {
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
      }
    );
    comments.value = res.data.record.comments;
  } catch (error) {
    if (error.response.status === 404) {
      showNotFound();
    }
  }
};

const showNotFound = () => {
  router.push({ name: "NotFound" });
};

const showEdit = () => {
  router.push({ name: "EditRecord", params: { id: recordId.value } });
};
</script>

<template>
  <Header />
  <TabMenu :currentId="0" />
  <Toast position="top-center" />
  <div class="wrap">
    <div class="main ml-5">
      <div class="main_content">
        <div class="editor">
          <p class="record-title">{{ date }}の記録</p>
          <p class="record-content" v-html="renderedMarkdown" />
          <div v-if="imageUrls !== null && imageUrls.length !== 0">
            <p class="mt-5">関連画像</p>
            <div class="thumbnail-container">
              <div class="thumbnail" v-for="item in imageUrls">
                <RelationImage :item=item />
              </div>
            </div>
          </div>
        </div>
        <div v-if="author !== null" class="radius-section pt-2.5">
          <Author :author="author" :userId="record.user_id" />
        </div>
        <div class="radius-section">
          <div class="comment-container-title-area">
            <p class="ml-5 pt-5 font-bold">コメント</p>
          </div>
          <div v-if="comments.length !== 0">
            <Comments :comments="comments" />
          </div>
          <div v-else>
            <p class="pt-2.5 pl-5">コメントはありません</p>
          </div>
          <CommentInput @addComment="addComment" />
        </div>
      </div>
    </div>
    <div class="side">
      <div class="side_content">
        <button v-if="isSupport" class="round-button">
          <img
            src="../../assets/image/support_off.png"
            alt="応援"
            class="side-menu-image"
            @click="supportClick(true)"
          />
        </button>
        <button v-else class="round-button">
          <img
            src="../../assets/image/support_off.png"
            alt="応援解除"
            class="side-menu-image"
            @click="supportClick(false)"
          />
        </button>
        <button class="round-button" v-show="isMyRecord">
          <img
            src="../../assets/image/edit.png"
            alt="編集"
            class="side-menu-image"
            @click="showEdit"
          />
        </button>
        <button class="round-button" v-show="isMyRecord">
          <img
            src="../../assets/image/delete.png"
            alt="削除"
            class="side-menu-image"
            @click="deleteRecord"
          />
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.wrap {
  display: grid;
  grid-template-columns: 4fr 1fr;
  background-color: #f5f6f6;
  padding-top: 20px;
}
.side_content {
  position: sticky;
  top: 100px;
  margin-left: 30px;
  display: flex;
  flex-flow: column;
  gap: 10px;
}
.editor {
  padding: 30px;
  border-radius: 8px;
  background-color: #ffffff;
}
input[type="text"] {
  width: 100%;
  padding: 12px 12px;
  margin: 8px 0;
  box-sizing: border-box;
  border: 1px solid #ccc;
  border-radius: 4px;
}
.record-title {
  font-weight: bold;
  font-size: 22px;
}
.record-content {
  font-size: 22px;
  padding-top: 20px;
}
.radius-section {
  margin-top: 20px;
  border-radius: 8px;
  background-color: #ffffff;
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
.round-button {
  padding: 0;
  background: transparent;
  border: 1px solid #ccc;
  border-radius: 50%;
  width: 60px;
  height: 60px;
}
.side-menu-image {
  max-width: 100%;
  height: auto;
  object-fit: cover;
}
.comment-container-title-area {
  border-bottom: 1px solid rgba(6, 6, 6, 0.17);
}

@media (max-width: 768px) {
  .wrap {
    display: flex;
    flex-direction: column;
  }

  .main {
    padding-bottom: 65px;
    margin-right: 20px;
  }

  .side {
    position: fixed;
    align-items: center;
    bottom: 0;
    left: 0;
    right: 0;
    z-index: 1;
    background-color: #fff;
    box-shadow: 0 -2px 5px rgba(0, 0, 0, 0.1);
  }

  .side_content {
    display: flex;
    flex-direction: row;
    gap: 10px;
    padding: 10px;
  }

  .round-button {
    padding: 0;
    background: transparent;
    border: 1px solid #ccc;
    border-radius: 50%;
    width: 45px;
    height: 45px;
  }
}
</style>
