<script setup>
import { ref, onMounted, watch } from "vue";

import Paginate from "vuejs-paginate-next";

const pageCount = ref(0);

const props = defineProps({
  pageCount: Number,
});

onMounted(() => {
  pageCount.value = props.pageCount;
});

watch(props, () => {
  pageCount.value = props.pageCount;
});

const emits = defineEmits(["changePage"]);

const clickCallback = function (pageNum) {
  emits("changePage", pageNum);
};
</script>

<template>
  <Paginate
    :page-count="pageCount"
    :page-range="3"
    :margin-pages="2"
    :click-handler="clickCallback"
    :prev-text="'<'"
    :next-text="'>'"
  />
</template>

<style scoped>
.pagination {
  display: flex;
  justify-content: center;
  margin-top: 20px;
  list-style: none;
}

:deep .page-item {
  color: #333;
  text-decoration: none;
  transition: background-color 0.3s;
  border: 1px solid #ddd;
  margin: 0 4px;
  width: 30px;
  height: 30px;
  padding: 20px;
}

:deep .page-link {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0;
  margin: 0;
}

:deep .page-item.active {
  background-color: #ffa500;
  color: white;
  border: 1px solid #ffa500;
}

:deep .page-item.disabled {
  cursor: not-allowed;
  color: #332;
}

:deep .page-item:hover:not(.disabled):not(.active) {
  background-color: #f5c977;
}

:deep .page-link.disabled {
  color: #ccc;
  cursor: not-allowed;
}
</style>
