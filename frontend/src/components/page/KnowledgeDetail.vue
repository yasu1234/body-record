<script setup>
import { ref, onMounted, computed } from "vue";
import axios from "axios";
import { useRoute, useRouter } from "vue-router";
import Cookies from "js-cookie";
import MarkdownIt from "markdown-it";

import Header from "../layout/Header.vue";
import TabMenu from "../layout/TabMenu.vue";
import Comments from "../layout/Comments.vue";
import CommentInput from "../layout/CommentInput.vue";
import Author from "../layout/Author.vue";
import RelationImage from "../layout/RelationImage.vue";

const route = useRoute();
const router = useRouter();

const knowledge = ref(null);
const imageUrls = ref([]);
const knowledgeId = ref(null);
const isBookmark = ref(false);
const isMyKnowledge = ref(false);
const comments = ref([]);
const author = ref(null);

const md = new MarkdownIt();

const renderedMarkdown = computed(() => {
  if (knowledge.value && knowledge.value.content) {
    return md.render(knowledge.value.content);
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
      import.meta.env.VITE_APP_API_BASE + `/api/v1/knowledges/${id}`,
      {
        headers: {
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
      }
    );
    knowledgeId.value = res.data.knowledge.id;
    knowledge.value = res.data.knowledge;
    imageUrls.value = res.data.knowledge.image_urls;
    isBookmark.value = res.data.isBookmark;
    author.value = res.data.knowledge.user;
  } catch (error) {
    if (error.response.status === 404) {
      showNotFound();
    }
  }
};

const getComments = async () => {
  try {
    const res = await axios.get(
      import.meta.env.VITE_APP_API_BASE + `/api/v1/comments/knowledge`,
      {
        headers: {
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
        params: {
          knowledge_id: route.params.id,
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

const bookmarkOn = async () => {
  try {
    const formData = new FormData();
    formData.append("bookmark[knowledge_id]", knowledgeId.value);

    const res = await axios.post(
      import.meta.env.VITE_APP_API_BASE + `/api/v1/bookmarks`,
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
    knowledge.value = res.data.knowledge;
    isBookmark.value = res.data.knowledge.isBookmark;
  } catch (error) {
    if (error.response.status === 404) {
      showNotFound();
    }
  }
};

const bookmarkOff = async () => {
  try {
    const res = await axios.delete(
      import.meta.env.VITE_APP_API_BASE +
        `/api/v1/bookmarks/${knowledgeId.value}`,
      {
        headers: {
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
      }
    );
    knowledge.value = res.data.knowledge;
    isBookmark.value = res.data.knowledge.isBookmark;
  } catch (error) {
    if (error.response.status === 404) {
      showNotFound();
    }
  }
};

function bookmarkClick(isBookmarkOn) {
  if (isBookmarkOn === true) {
    bookmarkOff();
  } else {
    bookmarkOn();
  }
}

const addComment = async (comment) => {
  try {
    const formData = new FormData();
    formData.append("knowledge_id", knowledgeId.value);
    formData.append("comment", comment.value);

    const res = await axios.post(
      import.meta.env.VITE_APP_API_BASE + `/api/v1/comments/knowledge`,
      formData,
      {
        headers: {
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
      }
    );
    comments.value = res.data.comments;
  } catch (error) {
    comments.value = [];
    if (error.response.status === 404) {
      showNotFound();
    }
  }
};

const showNotFound = () => {
  router.push({ name: "NotFound" });
};

const showEdit = () => {
  router.push({ name: "EditKnowledge", params: { id: knowledgeId.value } });
};
</script>

<template>
  <Header />
  <TabMenu :currentId="0" />
  <div class="wrap">
    <div class="main">
      <div class="editor">
        <p
          id="title"
          class="knowledge-title"
          type="text"
          v-if="knowledge !== null"
        >
          {{ knowledge.title }}
        </p>
        <p class="knowledge-content" v-html="renderedMarkdown"></p>
        <div v-if="imageUrls.length !== 0">
          <p class="mt-5">関連画像</p>
          <div class="thumbnail-container">
            <div class="thumbnail" v-for="item in imageUrls">
              <RelationImage :item=item />
            </div>
          </div>
        </div>
      </div>
      <div v-if="author !== null" class="radius-section pt-2.5">
        <Author :author="author" :userId="knowledge.user_id" />
      </div>
      <div class="radius-section">
        <div class="comment-container-title-area">
          <p class="comment-container-title">コメント</p>
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
    <div class="side">
      <div class="side_content">
        <button v-if="isBookmark" class="round-button">
          <img
            src="../../assets/image/bookmark_on.png"
            alt="ブックマーク"
            class="side-menu-image"
            @click="bookmarkClick(true)"
          />
        </button>
        <button v-else class="round-button">
          <img
            src="../../assets/image/bookmark_off.png"
            alt="ブックマーク"
            class="side-menu-image"
            @click="bookmarkClick(false)"
          />
        </button>
        <button class="round-button" v-show="isMyKnowledge">
          <img
            src="../../assets/image/edit.png"
            alt="編集"
            class="side-menu-image"
            @click="showEdit"
          />
        </button>
        <button class="round-button" v-show="isMyKnowledge">
          <img
            src="../../assets/image/delete.png"
            alt="削除"
            class="side-menu-image"
            @click=""
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
.main {
  margin-left: 20px;
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
.knowledge-title {
  font-weight: bold;
  font-size: 22px;
}
.knowledge-content {
  font-size: 22px;
  padding-top: 20px;
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
.radius-section {
  margin-top: 20px;
  border-radius: 8px;
  background-color: #ffffff;
}
.comment-container-title-area {
  border-bottom: 1px solid rgba(6, 6, 6, 0.17);
}
.comment-container-title {
  margin-left: 20px;
  padding-top: 20px;
  font-weight: bold;
}
</style>
