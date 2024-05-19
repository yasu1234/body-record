<script setup>
import { ref, onMounted, watch } from "vue";

const props = defineProps(["author"]);

const author = ref(null);

onMounted(() => {
  author.value = props.author;
});

watch(props, () => {
  author.value = props.author;
});
</script>

<template>
  <div class="author">
    <div
      class="author-thumbnail-image"
      v-if="author !== null && author.image_url !== null"
    >
      <img
        :src="author.image_url.url"
        alt="ユーザー"
        class="author-thumbnail-image"
      />
    </div>
    <p class="author-name" v-if="author !== null">{{ author.name }}</p>
  </div>
</template>

<style scoped>
.author {
  display: flex;
  align-items: center;
  margin-top: 10px;
  margin-left: 20px;
}
.author-thumbnail-image {
  width: 40px;
  height: 40px;
  object-fit: cover;
  border-radius: 50%;
}
.author-name {
  margin-left: 10px;
}
</style>
