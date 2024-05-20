<script setup>
import { ref } from "vue";

const comment = ref("");

const emit = defineEmits(["addComment"]);

const addComment = () => {
  emit("addComment", comment);
};
</script>

<template>
  <textarea
    name="comment"
    rows="10"
    v-model="comment"
    class="comment-textarea"
    placeholder="コメントを入力"
  />
  <button class="comment-add-button" @click="addComment">
    コメントを投稿する
  </button>
</template>

<style scoped>
.comment-textarea {
  width: calc(100% - 40px);
  margin-top: 20px;
  margin-left: 20px;
  padding-left: 10px;
  border: 1px solid #ccc;
}
.comment-add-button {
  margin-bottom: 20px;
}
</style>
