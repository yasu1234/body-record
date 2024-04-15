<script setup>
import { ref } from 'vue'

import TabMenu from './TabMenu.vue'
import RecordList from './MyRecordList.vue'
import Header from './Header.vue'

defineProps({
  msg: String,
})

const currentId = ref(1);
</script>

<template>
  <Header />
  <TabMenu :currentId="currentId"/>
  <RecordList/>
</template>

<style scoped>
.read-the-docs {
  color: #888;
}
</style>
