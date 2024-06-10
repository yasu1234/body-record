<script setup>
import { ref } from "vue";

const comment = ref("");

const emit = defineEmits(["add-comment"]);

const addComment = () => {
  emit("add-comment", comment.value);
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
  <div class="add-commet-button-container mt-2.5 mr-5">
    <button class="mb-5 py-1.5 px-2.5" @click="addComment">コメントを投稿する</button>
  </div>
</template>

<style scoped>
.comment-textarea {
  width: calc(100% - 40px);
  margin-top: 20px;
  margin-left: 20px;
  padding-left: 10px;
  border: 1px solid #ccc;
}
.add-commet-button-container {
  display: flex;
  justify-content: flex-end;
}
</style>
