<script setup>
import { useRouter } from 'vue-router'
import { ref } from 'vue'

import TabItem from '../atom/TabItem.vue'

const router = useRouter();

const props = defineProps({
    currentId: Number
})

const menuList = ref([
  { id: 1, label: "My記録" },
  { id: 2, label: "みんなの記録" },
  { id: 3, label: "ノウハウ一覧" }
]);

function menuChange(event) {
  switch(event) {
    case 1:
      router.push({ name: 'Home'});
      break
    case 2:
      router.push({ name: 'OtherRecordList'})
      break
    case 3:
      router.push({ name: 'KnowledgeList'})
      break
    default:
      break
  }
}
</script>

<template>
    <div class="tab-menu">
      <TabItem
        v-for="item in menuList"
        v-bind="item" :menuId="item.id"
        :menuTitle="item.label"
        :currentId="currentId"
        @menuTapped="menuChange" />
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