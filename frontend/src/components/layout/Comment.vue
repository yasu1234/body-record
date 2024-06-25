<template>
  <div v-if="!isEditing">
    <div class="comment-header pr-2.5">
      <div class="comment-user">
        <div class="comment-thumbnail-image" v-if="imageUrl != null && imageUrl.url != null">
          <img :src="imageUrl.url" alt="ユーザー" class="comment-thumbnail-image" />
        </div>
        <p class="ml-2.5">{{ userName }}</p>
      </div>
      <div v-if="isMineComment" class="menu-container">
        <button class="menu-button" @click="toggleDropdown" v-on-click-outside="onClickOutsideHandler">
          <MeatBallMenu />
        </button>
        <div v-if="showDropdown" class="dropdown-menu">
          <button
            v-for="menu in menuList"
            class="menu-item"
            @click="showMenu(menu)"
          >
            {{ menu.label }}
          </button>
        </div>
      </div>
    </div>
    <p class="pt-2.5 mb-1.5">{{ comment }}</p>
    <p class="comment-date pr-2.5 mb-2.5">
      {{ commentDate }}
    </p>
  </div>
  <div v-if="isEditing" class="mt-2.5 mr-5">
    <textarea
      name="comment"
      rows="10"
      v-model="inputComment"
      class="comment-textarea"
      placeholder="コメントを入力"
    />
    <div class="text-right mr-5">
      <p v-if="comment.length > 300" class="text-red-500">
        300文字以上入力しています
      </p>
      <p v-else>残り{{ 300 - comment.length }}文字入力できます</p>
    </div>
    <div class="comment-container mr-5 mt-2.5 mb-5">
      <button class="comment-cancel-button px-1.5 mr-2.5" @click="editCancel">
        キャンセル
      </button>
      <button class="px-1.5" @click="editComment">
        コメントを編集する
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from "vue";
import { CommentMenuList } from "../../js/const.js";
import { vOnClickOutside } from "@vueuse/components";

import MeatBallMenu from "../atom/MeatBallMenu.vue";

const props = defineProps(["comment", "isEditing"]);
const emit = defineEmits(["edit-comment", "delete-comment"]);

const menuList = ref(CommentMenuList);
const showDropdown = ref(false);
const commentId = ref(0);
const userName = ref("");
const comment = ref("");
const imageUrl = ref(null);
const commentDate = ref("");
const isMineComment = ref(false);
const isEditing = ref(false);
const inputComment = ref("");

onMounted(() => {
  setProps(props);
});

watch(props, () => {
  setProps(props);
});

const setProps = (props) => {
  isEditing.value = props.isEditing;
  if (props.comment == null) {
    userName.value = "";
    comment.value = "";
    commentDate.value = "";
    imageUrl.value = null;
    isMineComment.value = false;
    commentId.value = 0;
    return;
  }

  commentId.value = props.comment.id;
  comment.value = props.comment.comment;
  userName.value = props.comment.user.name;
  imageUrl.value = props.comment.user.image_url;
  commentDate.value = props.comment.comment_date_format;
  isMineComment.value = props.comment.is_mine_comment;
};

const toggleDropdown = () => {
  showDropdown.value = !showDropdown.value;
};

const onClickOutsideHandler = () => {
  showDropdown.value = false;
};

const editComment = () => {
  emit("edit-comment", inputComment.value, commentId.value);
};

const editCancel = () => {
  isEditing.value = false;
};

const showMenu = (menu) => {
  switch (menu.id) {
    case 1:
      showDropdown.value = false;
      isEditing.value = true;
      inputComment.value = comment.value;
      break;
    case 2:
      emit("delete-comment");
      showDropdown.value = false;
      isEditing.value = false;
      break;
    default:
      showDropdown.value = false;
      break;
  }
};
</script>

<style scoped>
.comment-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.comment-user {
  display: flex;
  align-items: center;
  margin-top: 10px;
}
.comment-thumbnail-image {
  width: 40px;
  height: 40px;
  border-radius: 50%;
}
.comment-date {
  color: #928484;
  font-size: 12px;
  text-align: right;
}
.menu-button {
  background: #fff;
}
.menu-container {
  position: relative;
}
.dropdown-menu {
  position: absolute;
  background-color: #f1f1f1;
  min-width: 160px;
  box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
  z-index: 2;
  display: flex;
  flex-direction: column;
  border-radius: 4px;
  right: 0px;
  top: 32px;
}
.menu-item {
  padding: 6px;
  background: #ffffff;
  color: #000000;
  border-radius: 0px;
}
.comment-container {
  display: flex;
  justify-content: flex-end;
}
.comment-textarea {
  width: calc(100% - 40px);
  margin-top: 20px;
  margin-left: 20px;
  padding-left: 10px;
  border: 1px solid #ccc;
}
.comment-cancel-button {
  background: #fff;
  color: #000000;
  border: 1px solid #ccc;
  cursor: pointer;
}
</style>
