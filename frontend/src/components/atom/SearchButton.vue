<script setup>
import Button from "primevue/button";

const emit = defineEmits(["searchButtonClick"]);

const searchButtonClick = () => {
  emit("searchButtonClick");
};
</script>

<template>
  <Button
    label="この条件で検索する"
    icon="pi pi-search"
    class="search-button"
    @click="searchButtonClick"
  />
</template>

<style scoped>
.search-button {
  background: #46c443;
  color: white;
  font-size: 16px;
  font-weight: bold;
}
</style>
