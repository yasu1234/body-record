<script setup>
import { ref, onMounted, watch } from "vue";

const props = defineProps(["author", "support"]);
const emit = defineEmits(["support-on", "support-off"]);

const author = ref(null);
const support = ref(null);

onMounted(() => {
  setProps();
});

watch(props, () => {
  setProps();
});

const setProps = () => {
  author.value = props.author;
  support.value = props.support;
};

const supportOn = () => {
  emit("support-on");
};

const supportOff = () => {
  emit("support-off");
};
</script>

<template>
  <div class="author">
    <div
      class="author-thumbnail-image"
      v-if="
        author !== null &&
        author.image_url !== null &&
        author.image_url.url !== null
      "
    >
      <img
        :src="author.image_url.url"
        alt="ユーザー"
        class="author-thumbnail-image"
      />
    </div>
    <p class="ml-2.5" v-if="author !== null">{{ author.name }}</p>
  </div>
  <div class="support-container mt-2.5 ml-5 pb-5">
    <button v-if="support !== null && support.is_support" class="support-button">
      <img
        src="../../assets/image/support_on.png"
        alt="ユーザー"
        class="support-image"
        @click="supportOff"
      />
    </button>
    <button v-else class="support-button">
      <img
        src="../../assets/image/support_off.png"
        alt="ユーザー"
        class="support-image"
        @click="supportOn"
      />
    </button>
    <p class="ml-2.5" v-if="support !== null">{{ support.supporter_count }}</p>
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
  border-radius: 50%;
}
.support-container {
  display: flex;
  align-items: center;
}
.support-button {
  width: 50px;
  height: 50px;
  background: transparent;
  border: 1px solid #ccc;
  border-radius: 50%;
}
.support-image {
  width: 100%;
  height: auto;
}
</style>
