<template>
  <FloatLabel class="mt-5">
    <Textarea
      v-model="knowledgeContent"
      rows="20"
      class="w-full p-2.5"
      @change="contentChange"
    />
    <label>詳細</label>
  </FloatLabel>
  <div class="mt-2 text-right">
    <p v-if="knowledgeContent.length > 5000" class="text-red-500">
      400文字以上入力しています
    </p>
    <p v-else>残り{{ 5000 - knowledgeContent.length }}文字入力できます</p>
  </div>
</template>

<script setup>
import { ref, watch } from "vue";
import Textarea from "primevue/textarea";
import FloatLabel from "primevue/floatlabel";

const knowledgeContent = ref("");

const props = defineProps(["knowledgeContent"]);

watch(props, () => {
  knowledgeContent.value = props.knowledgeContent;
});

const emit = defineEmits(["content-edit"]);

const contentChange = () => {
  emit("content-edit", knowledgeContent.value);
};
</script>

<style scoped>
</style>
