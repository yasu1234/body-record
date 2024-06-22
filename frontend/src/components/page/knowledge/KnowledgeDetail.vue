<script setup>
import { ref, onMounted, computed } from "vue";
import { useRoute, useRouter } from "vue-router";
import MarkdownIt from "markdown-it";
import { axiosInstance, setupInterceptors } from "../../../js/axios.js";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../../js/toast.js";
import Toast from "primevue/toast";

import Header from "../../layout/Header.vue";
import TabMenu from "../../layout/TabMenu.vue";
import Comments from "../../layout/Comments.vue";
import CommentInput from "../../layout/CommentInput.vue";
import Author from "../../layout/Author.vue";
import RelationImage from "../../layout/RelationImage.vue";
import ConfirmDialog from "../../layout/ConfirmDialog.vue";

const route = useRoute();
const router = useRouter();
setupInterceptors(router);
const toast = useToast();
const toastNotifications = new toastService(toast);

const knowledge = ref(null);
const imageUrls = ref([]);
const knowledgeId = ref(null);
const knowledgeUserId = ref(0);
const isBookmark = ref(false);
const isMyKnowledge = ref(false);
const comments = ref([]);
const author = ref(null);
const bookmarkCount = ref(0);
const support = ref(null);
const deleteCommentId = ref(0);
const isShowCommentDeleteConfirmDialog = ref(false);
const isEditing = ref(false);
const isShowKnowledgeDeleteConfirmDialog = ref(false);

const md = new MarkdownIt({
  breaks: true,
  html: true
});

const renderedMarkdown = computed(() => {
  if (knowledge.value != null && knowledge.value.content != null) {
    let replacedContent = knowledge.value.content.replace(/\n/g, '<br>');
    return md.render(replacedContent);
  }
  return "";
});

onMounted(() => {
  getDetail();
  getComments();
});

const getDetail = async () => {
  knowledgeId.value = route.params.id;
  try {
    const res = await axiosInstance.get(
      `/api/v1/knowledges/${knowledgeId.value}`
    );
    knowledgeId.value = res.data.knowledge.id;
    knowledge.value = res.data.knowledge;
    knowledgeUserId.value = res.data.knowledge.user_id;
    imageUrls.value = res.data.knowledge.image_urls;
    isBookmark.value = res.data.knowledge.is_bookmark;
    author.value = res.data.knowledge.user;
    isMyKnowledge.value = res.data.knowledge.is_my_knowledge;
    bookmarkCount.value = res.data.knowledge.bookmark_count;

    getSupport();
  } catch (error) {
    let errorMessage = "";
    if (error.response != null && error.response.status === 401) {
      errorMessage = "ログインしてください";
    }

    toastNotifications.displayError("記事データの取得に失敗しました", "");
  }
};

const getSupport = async () => {
  try {
    const res = await axiosInstance.get(`/api/v1/support_counts`, {
      params: {
        user_id: knowledgeUserId.value,
      },
    });

    support.value = res.data.user;
  } catch (error) {
    support.value = null;
  }
};

const getComments = async () => {
  try {
    const res = await axiosInstance.get(`/api/v1/knowledge_comments`, {
      params: {
        knowledge_id: route.params.id,
      },
    });
    comments.value = res.data.comments;
  } catch (error) {
    comments.value = [];
  }
};

const deleteKnowledge = async () => {
  try {
    const res = await axiosInstance.delete(`/api/v1/knowledges/${knowledgeId.value}`);

    toastNotifications.displayInfo("記事を削除しました", "");
    setTimeout(async () => {
      showKnowledgeList();
    }, 3000);
  } catch (error) {
    if (error.response == null) {
      toastNotifications.displayError("記事削除に失敗しました", "");
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

    toastNotifications.displayError("記事削除に失敗しました", errorMessages);
  }
};

const bookmarkOn = async () => {
  try {
    const formData = new FormData();
    formData.append("bookmark[knowledge_id]", knowledgeId.value);

    const res = await axiosInstance.post(`/api/v1/bookmarks`, formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });
    knowledge.value = res.data.knowledge;
    isBookmark.value = res.data.knowledge.isBookmark;
    bookmarkCount.value = res.data.knowledge.bookmark_count;
  } catch (error) {
    let errorMessages = "";
    if (error.response != null && error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      }
    }
    toastNotifications.displayError(
      "ブックマークの登録に失敗しました",
      errorMessages
    );
  }
};

const bookmarkOff = async () => {
  try {
    const res = await axiosInstance.delete(
      `/api/v1/bookmarks/${knowledgeId.value}`
    );
    knowledge.value = res.data.knowledge;
    isBookmark.value = res.data.knowledge.isBookmark;
    bookmarkCount.value = res.data.knowledge.bookmark_count;
  } catch (error) {
    let errorMessages = "";
    if (error.response != null && error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      }
    }
    toastNotifications.displayError(
      "ブックマークの解除に失敗しました",
      errorMessages
    );
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
    formData.append("comment[knowledge_id]", knowledgeId.value);
    formData.append("comment[comment]", comment);

    const res = await axiosInstance.post(
      `/api/v1/knowledge_comments`,
      formData
    );
    getComments();
  } catch (error) {
    let errorMessages = "";
    if (error.response != null && error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      } else {
        errorMessages = error.response.data.errors;
      }
    }
    toastNotifications.displayError(
      "コメントの追加に失敗しました",
      errorMessages
    );
  }
};

const supportOn = async () => {
  try {
    const formData = new FormData();
    formData.append("id", knowledgeUserId.value);

    const res = await axiosInstance.post(`/api/v1/supports`, formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });
    getSupport();
  } catch (error) {
    let errorMessages = "";
    if (error.response != null && error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      } else {
        errorMessages = error.response.data.errors;
      }
    }
    toastNotifications.displayError("応援に失敗しました", errorMessages);
  }
};

const supportOff = async () => {
  try {
    const res = await axiosInstance.delete(
      `/api/v1/supports/${knowledgeUserId.value}`
    );
    getSupport();
  } catch (error) {
    let errorMessages = "";
    if (error.response != null && error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      } else {
        errorMessages = error.response.data.errors;
      }
    }
    toastNotifications.displayError("応援解除に失敗しました", errorMessages);
  }
};

const deleteComment = async () => {
  isShowCommentDeleteConfirmDialog.value = false;
  try {
    const res = await axiosInstance.delete(
      `/api/v1/knowledge_comments/${deleteCommentId.value}`
    );
    deleteCommentId.value = 0;
    getComments();
  } catch (error) {
    if (error.response == null) {
      toastNotifications.displayError("コメント削除に失敗しました", "");
      return;
    }

    let errorMessages = "";
    if (error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      } else {
        errorMessages += error.response.data.errors;
      }
    } else if (error.response.status === 401) {
      errorMessages = "ログインしてください";
    }

    toastNotifications.displayError(
      "コメント削除に失敗しました",
      errorMessages
    );
    deleteCommentId.value = 0;
  }
};

const editComment = async (inputComment, commentId) => {
  if (commentId == null) {
    toastNotifications.displayError("コメント編集に失敗しました", "");
    return;
  }

  try {
    const formData = new FormData();
    formData.append("comment[knowledge_id]", knowledgeId.value);
    formData.append("comment[comment]", inputComment);

    const res = await axiosInstance.put(
      `/api/v1/knowledge_comments/${commentId}`, formData
    );
    isEditing.value = false;
    deleteCommentId.value = 0;
    getComments();
  } catch (error) {
    if (error.response == null) {
      toastNotifications.displayError("コメント編集に失敗しました", "");
      return;
    }

    let errorMessages = "";
    if (error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      } else {
        errorMessages += error.response.data.errors;
      }
    } else if (error.response.status === 401) {
      errorMessages = "ログインしてください";
    }

    toastNotifications.displayError(
      "コメント編集に失敗しました",
      errorMessages
    );
    deleteCommentId.value = 0;
  }
};

const showCommentDeleteDialog = (comment) => {
  isShowCommentDeleteConfirmDialog.value = true;
  deleteCommentId.value = comment.id;
};

const showKnowledgeDeleteConfirmDialog = () => {
  isShowKnowledgeDeleteConfirmDialog.value = true;
};

const knowledgeDelete = () => {
  isShowKnowledgeDeleteConfirmDialog.value = false;
  deleteKnowledge();
};

const cancelKnowledgeDelete = () => {
  isShowKnowledgeDeleteConfirmDialog.value = false;
};

const showEdit = () => {
  router.push({ name: "EditKnowledge", params: { id: knowledgeId.value } });
};

const showKnowledgeList = () => {
  router.push({ name: "KnowledgeList" });
};
</script>

<template>
  <Header />
  <TabMenu :currentId="0" />
  <Toast position="top-center" />
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
              <RelationImage :item="item" />
            </div>
          </div>
        </div>
      </div>
      <div v-if="author !== null" class="radius-section pt-2.5">
        <Author
          :author="author"
          :support="support"
          @suport-on="supportOn"
          @support-off="supportOff"
        />
      </div>
      <div class="radius-section mb-5">
        <div class="comment-container-title-area">
          <p class="comment-container-title">コメント</p>
        </div>
        <div v-if="comments.length > 0">
          <div v-for="comment in comments" class="comment">
            <Comments
              :comment="comment"
              :isEditing="isEditing"
              @delete-comment="showCommentDeleteDialog(comment)"
              @edit-comment="editComment"
            />
          </div>
          <div v-if="isShowCommentDeleteConfirmDialog" class="modal-overlay">
            <ConfirmDialog
              :title="'コメントを削除します'"
              :message="'よろしいですか？'"
              :positiveButtonTitle="'削除'"
              @handle-positive="deleteComment"
              @cancel="cancelCommentDelete"
            />
          </div>
        </div>
        <div v-else>
          <p class="pt-2.5 pl-5">コメントはありません</p>
        </div>
        <CommentInput @add-comment="addComment" />
      </div>
    </div>
    <div class="side">
      <div class="side-content">
        <div class="bookmark-button-container">
          <button
            v-if="isBookmark"
            class="round-button"
            @click="bookmarkClick(true)"
          >
            <img
              src="../../../assets/image/bookmark_on.png"
              alt="ブックマーク解除"
              v-tooltip="{ value: 'ブックマーク解除' }"
              class="side-menu-image"
            />
          </button>
          <button v-else class="round-button" @click="bookmarkClick(false)">
            <img
              src="../../../assets/image/bookmark_off.png"
              alt="ブックマーク"
              v-tooltip="{ value: 'ブックマークする' }"
              class="side-menu-image"
            />
          </button>
          <p class="text-center">{{ bookmarkCount }}</p>
        </div>
        <button class="round-button" v-show="isMyKnowledge">
          <img
            src="../../../assets/image/edit.png"
            alt="編集"
            v-tooltip="{ value: '編集' }"
            class="side-menu-image"
            @click="showEdit"
          />
        </button>
        <button class="round-button" v-show="isMyKnowledge">
          <img
            src="../../../assets/image/delete.png"
            alt="削除"
            v-tooltip="{ value: '削除' }"
            class="side-menu-image"
            @click="showKnowledgeDeleteConfirmDialog"
          />
        </button>
      </div>
    </div>
    <div v-if="isShowKnowledgeDeleteConfirmDialog" class="modal-overlay">
      <ConfirmDialog
        :title="'記事を削除します'"
        :message="'よろしいですか？'"
        :positiveButtonTitle="'削除'"
        @handle-positive="knowledgeDelete"
        @cancel="cancelKnowledgeDelete"
      />
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
.side-content {
  position: sticky;
  top: 100px;
  margin-left: 30px;
  display: flex;
  flex-flow: column;
  gap: 15px;
}
.main {
  margin-left: 20px;
}
.bookmark-button-container {
  padding: 0;
  background: transparent;
  width: 60px;
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
.comment {
  padding-left: 20px;
  border-bottom: 1px solid rgba(6, 6, 6, 0.17);
}

@media (max-width: 768px) {
  .wrap {
    display: flex;
    flex-direction: column;
  }
  .main {
    padding-bottom: 85px;
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
  .side-content {
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
  .bookmark-button-container {
    width: 45px;
  }
}
</style>
