<template>
  <Button
    label="この条件で検索する"
    icon="pi pi-search"
    class="search-button p-2.5"
    @click="searchButtonClick"
  />
</template>

<script setup>
import Button from "primevue/button";

const emit = defineEmits(["search-button-click"]);

const searchButtonClick = () => {
  emit("search-button-click");
};
</script>

<style scoped>
.search-button {
  background: #46c443;
  font-size: 16px;
  font-weight: bold;
}
</style>
