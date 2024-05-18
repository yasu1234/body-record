<script setup>
import { ref, onMounted } from "vue";

const props = defineProps(["thumbnail", "name", "comment"]);

const thumbnail = ref(null);
const comment = ref(null);
const name = ref(null);

onMounted(() => {
  thumbnail.value = props.thumbnail;
  name.value = props.name;
  comment.value = props.comment;
});
</script>

<template>
  <div class="comment-user">
    <div class="comment-thumbnail-image" v-show="thumbnail !== null">
      <img :src="thumbnail" alt="ユーザー" class="comment-thumbnail-image" />
    </div>
    <p class="comment-name">{{ name }}</p>
  </div>
  <p>{{ comment }}</p>
</template>

<style scoped>
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
