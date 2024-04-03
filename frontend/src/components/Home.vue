<script setup>
import { ref } from 'vue'

import TabMenu from './TabMenu.vue'

defineProps({
  msg: String,
})

const currentId = ref(1);
</script>

<template>
  <TabMenu :currentId="currentId"/>
</template>

<style scoped>
.read-the-docs {
  color: #888;
}
</style>
