<script setup>
import { ref, onMounted } from "vue";
import { useRouter, onBeforeRouteUpdate, useRoute } from "vue-router";
import { axiosInstance } from "../../../const/axios.js";

import ListPage from "../../layout/ListPage.vue";
import DatePicker from "../../atom/DatePicker.vue";
import SearchButton from "../../atom/SearchButton.vue";
import RecordCard from "../../layout/RecordCard.vue";
import ResultEmpty from "../../atom/ResultEmpty.vue";

const router = useRouter();
const route = useRoute();

const keyword = ref("");
const startDate = ref("");
const endDate = ref("");
const isOnlyOpen = ref(false);
const isLogin = ref(false);
const searchResult = ref([]);
const pageCount = ref(1);
const page = ref(1);

onMounted(() => {
  setQuery(
    route.query.keyword,
    route.query.startDate,
    route.query.endDate,
    route.query.page,
    route.query.isOnlyOpen
  );
  search();
});

onBeforeRouteUpdate(async (to, from) => {
  setQuery(
    to.query.keyword,
    to.query.startDate,
    to.query.endDate,
    to.query.page,
    to.query.isOnlyOpen
  );
  search();
});

const paramChange = () => {
  const query = {};

  if (keyword.value.trim() !== "") {
    query.keyword = keyword.value;
  }

  if (startDate.value !== "") {
    query.startDate = startDate.value;
  }

  if (endDate.value !== "") {
    query.endDate = endDate.value;
  }

  if (page.value > 1) {
    query.page = page.value;
  }

  if (isOnlyOpen.value != null && isOnlyOpen.value === true) {
    query.isOnlyOpen = isOnlyOpen.value;
  }

  router.push({ path: "/", query: query });
};

const search = async () => {
  try {
    const res = await axiosInstance.get("/api/v1/my_records", {
      params: {
        keyword: keyword.value,
        startDate: startDate.value,
        endDate: endDate.value,
        is_only_open: isOnlyOpen.value,
        page: page.value,
      },
    });

    if (res.data && res.data.totalPage) {
      pageCount.value = res.data.totalPage;
    } else {
      pageCount.value = 1;
    }

    searchResult.value = [];

    for (let item of res.data.records) {
      searchResult.value.push(item);
    }
  } catch (error) {
    searchResult.value = [];
  }
};

const setQuery = (keywordParam, startDateParam, endDateParam, pageParam, isOnlyOpenParam) => {
  if (keywordParam != null) {
    keyword.value = keywordParam;
  } else {
    keyword.value = "";
  }
  if (startDateParam != null) {
    startDate.value = startDateParam;
  } else {
    startDate.value = "";
  }
  if (endDateParam != null) {
    endDate.value = endDateParam;
  } else {
    endDate.value = "";
  }
  if (pageParam != null) {
    page.value = pageParam;
  } else {
    page.value = 1;
  }

  if (isOnlyOpenParam != null && isOnlyOpenParam === 'true') {
    isOnlyOpen.value = true;
  } else {
    isOnlyOpen.value = false;
  }
};

const updatePaginateItems = function (pageParam) {
  page.value = pageParam;
  paramChange();
};

function startDateChange(event) {
  startDate.value = event;
}

function endDateChange(event) {
  endDate.value = event;
}

const clickRecord = (item) => {
  router.push({ name: "RecordDetail", params: { id: item.id } });
};

const addRecord = () => {
  router.push({ name: "AddRecord" });
};
</script>

<template>
  <div class="record-search-container">
    <input
      type="text"
      id="keyword"
      name="keywordName"
      placeholder="キーワードで検索"
      v-model="keyword"
    />
    <div class="record-search-time-list">
      <div class="item">
        <p class="input-title">検索開始日</p>
        <DatePicker
          isStart="true"
          :date="startDate"
          @update:date="startDateChange"
        />
      </div>
      <div class="item">
        <p class="input-title">検索終了日</p>
        <DatePicker
          isStart="false"
          :date="endDate"
          @update:date="endDateChange"
        />
      </div>
    </div>
    <div class="mt-5">
      <input
        type="checkbox"
        id="statusSelect"
        v-model="isOnlyOpen"
        class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500"
      />
      <label class="ml-2">非公開記録は表示しない</label>
    </div>
    <div class="search-button-area">
      <SearchButton @searchButtonClick="paramChange" />
    </div>
  </div>
  <div class="add-button-area">
    <button class="add-button p-2.5" @click="addRecord">
      + 記録を追加する
    </button>
  </div>
  <div class="mt-5">
    <div v-if="searchResult.length > 0">
      <RecordCard
        v-for="record in searchResult"
        v-bind="record"
        :record="record"
        @recordClick="clickRecord(record)"
      />
      <div class="record-list-page">
        <ListPage
          :pageCount="pageCount"
          v-model="page"
          @changePage="updatePaginateItems"
        />
      </div>
    </div>
    <div v-else>
      <ResultEmpty class="mx-5" />
    </div>
  </div>
</template>

<style scoped>
input[type="text"] {
  width: 100%;
  padding: 12px 12px;
  margin: 8px 0;
  box-sizing: border-box;
  border: 1px solid #ccc;
  border-radius: 4px;
}
.record-search-time-list .item {
  padding: 5px;
  box-sizing: border-box;
}
.record-search-time-list .item .input-title {
  margin: 5px 0 0;
  padding: 0;
  font-size: 16px;
}
.search-button-area {
  text-align: center;
  margin-top: 20px;
}
.add-button-area {
  width: 700px;
  margin: 0 auto;
  margin-top: 20px;
  text-align: right;
}
.add-button {
  font-size: 16px;
  font-weight: bold;
}

@media screen and (max-width: 768px) {
  .add-button-area {
    width: auto;
    margin-left: 20px;
    margin-right: 20px;
    text-align: right;
  }
}
</style>
