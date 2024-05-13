<script setup>
import Button from "primevue/button";

const emit = defineEmits(["searchButtonClick"]);

const searchButtonClick = () => {
  emit("searchButtonClick");
};
</script>

<template>
  <Button
    label="検索"
    icon="pi pi-search"
    class="search-button"
    @click="searchButtonClick"
  />
</template>

<style scoped>
.search-button {
  background: #ffa500;
  color: white;
  font-size: 16px;
  font-weight: bold;
}
</style>
