<script setup>
import TabMenu from '../layout/TabMenu.vue'
import RecordList from '../page/record/MyRecordList.vue'
import Header from '../layout/Header.vue'
</script>

<template>
  <Header />
  <TabMenu :currentId="1"/>
  <RecordList/>
</template>

<style scoped>
</style>
