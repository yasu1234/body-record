<template>
  <div class="tab-menu">
    <TabItem
      v-for="item in TabMenuList"
      v-bind="item" :menuId="item.id"
      :menuTitle="item.label"
      :currentId="currentId"
      @menu-tapped="menuChange" />
  </div>
  <div class="tab-line h-px"/>
</template>


<script setup>
import { useRouter } from 'vue-router'

import TabItem from '../atom/TabItem.vue'
import { TabMenuList } from '../../js/const.js'

const router = useRouter();

const props = defineProps({
    currentId: Number
})

function menuChange(event) {
  switch(event) {
    case 1:
      router.push({ name: 'Home'});
      break
    case 2:
      router.push({ name: 'UserList'})
      break
    case 3:
      router.push({ name: 'KnowledgeList'})
      break
    default:
      break
  }
}
</script>

<style scoped>
.tab-menu {
  display: flex;
  padding-left: 16px;
  background-color: #ffffff;
  overflow-x: auto; /* 横方向のスクロールを許可 */
  white-space: nowrap;
}
.tab-line {
  background-color:rgb(232, 229, 229);
}
</style>
