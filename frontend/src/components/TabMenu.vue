<script setup>
import { useRouter } from 'vue-router'
import { ref } from 'vue'

import TabItem from './TabItem.vue'

const props = defineProps({
    currentId: Number
})

const menuList = ref([
  { id: 1, label: "My記録" },
  { id: 2, label: "みんなの記録" },
  { id: 3, label: "アイデア一覧" }
]);
</script>

<template>
    <div class="tab-menu">
      <TabItem
        v-for="item in menuList"
        v-bind="item" :menuId="item.id"
        :menuTitle="item.label"
        :currentId="currentId" />
    </div>
</template>

<style>
.item {
  box-sizing: border-box;
  padding: 10px;
  width: 100%;
  transition: all 0.8s ease;
}
.tab-menu {
    display: flex;
    margin-left: 16px;
}
</style>