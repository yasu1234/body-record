<template>
  <Header />
  <TabMenu :currentId="1"/>
  <RecordList/>
</template>

<script setup>
import TabMenu from '../layout/TabMenu.vue'
import RecordList from '../page/record/MyRecordList.vue'
import Header from '../layout/Header.vue'
</script>

<style scoped>
</style>
