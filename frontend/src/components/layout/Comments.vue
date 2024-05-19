<script setup>
import { ref, onMounted, watch } from "vue";

const props = defineProps(["comments"]);

const comments = ref([]);

onMounted(() => {
  comments.value = props.comments;
});

watch(props, () => {
  comments.value = props.comments;
});
</script>

<template>
  <div v-for="comment in comments" class="comment">
    <div class="comment-user">
      <div
        class="comment-thumbnail-image"
        v-show="comment.user.image_url.url !== null"
      >
        <img
          :src="comment.user.image_url.url"
          alt="ユーザー"
          class="comment-thumbnail-image"
        />
      </div>
      <p class="comment-name">{{ comment.user.name }}</p>
    </div>
    <p>{{ comment.comment }}</p>
  </div>
</template>

<style scoped>
.comment {
  padding-left: 20px;
  border-bottom: 1px solid rgba(6, 6, 6, 0.17);
}
.comment-user {
  display: flex;
  align-items: center;
  margin-top: 10px;
}
.comment-thumbnail-image {
  width: 40px;
  height: 40px;
  object-fit: cover;
  border-radius: 50%;
}
.comment-name {
  margin-left: 10px;
}
</style>
