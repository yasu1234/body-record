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
  <div class="add-comment-container mt-2.5 mr-5">
    <div class="mr-5">
      <p v-if="comment.length > 300" class="text-red-500">300文字以上入力しています</p>
      <p v-else>残り{{ 300 - comment.length }}文字入力できます</p>
    </div>
    <button class="mb-5 py-1.5 px-2.5" @click="addComment">
      コメントを投稿する
    </button>
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
.add-comment-container {
  display: flex;
  justify-content: flex-end;
}

@media screen and (max-width: 768px) {
  .add-comment-container {
    flex-direction: column;
  }
}
</style>
