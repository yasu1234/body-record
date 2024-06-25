<script setup>
import { ref, onMounted, watch } from "vue";

import Image from "primevue/image";

const props = defineProps(["item"]);

const item = ref(null);

onMounted(() => {
  item.value = props.item;
});

watch(props, () => {
  item.value = props.item;
});
</script>

<template>
  <div class="" v-if="item != null">
    <Image
      :src="item.url"
      class="thumbnail-image"
      alt=""
      preview
      :pt="{
        image: {
          style: {
            width: '100%',
            height: '100%'
          },
        },
        button: {
          style: {
            background: '#F7F7F770',
          },
        },
        closeButton: {
          style: {
            background: 'transparent',
          },
        },
        zoomInButton: {
          style: {
            background: 'transparent',
          },
        },
        zoomOutButton: {
          style: {
            background: 'transparent',
          },
        },
        rotateRightButton: {
          style: {
            display: 'none',
          },
        },
        rotateLeftButton: {
          style: {
            display: 'none',
          },
        },
      }"
    />
    <p class="text-center mt-2.5">{{ item.filename }}</p>
  </div>
</template>

<style scoped>
.thumbnail-image {
  width: 300px;
  height: 200px;
  object-fit: cover;
}
.thumbnail-image img {
  width: 300px;
  height: 200px;
}
.p-image-action {
  background: transparent;
}

@media screen and (max-width: 768px) {
  .thumbnail-image {
    width: auto;
    height: 100%;
    margin-left: 0px;
    margin-right: 0px;
  }
}
</style>
