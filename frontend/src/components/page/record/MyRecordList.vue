<script setup>
import { ref, onMounted } from "vue";
import { useRouter, onBeforeRouteUpdate, useRoute } from "vue-router";
import { axiosInstance } from "../../../js/axios.js";

import ListPage from "../../layout/ListPage.vue";
import DatePicker from "../../atom/DatePicker.vue";
import SearchButton from "../../atom/SearchButton.vue";
import RecordCard from "../../layout/RecordCard.vue";
import ResultEmpty from "../../atom/ResultEmpty.vue";
import LoginIntroductionView from "../../layout/LoginIntroductionView.vue";

const router = useRouter();
const route = useRoute();

const keyword = ref("");
const startDate = ref("");
const endDate = ref("");
const isOnlyOpen = ref(false);
const searchResult = ref([]);
const pageCount = ref(1);
const page = ref(1);
const isEmpty = ref(false);
const shouldLogin = ref(false);
const totalCount = ref(0);

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
  shouldLogin.value = false;

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

    searchResult.value = [];

    if (res.data && res.data.total_page) {
      pageCount.value = res.data.total_page;
    } else {
      pageCount.value = 1;
    }

    if (res.data != null && res.data.total_count != null) {
      totalCount.value = res.data.total_count;
    } else {
      totalCount.value = 0;
    }

    if (res.data.records != null && res.data.records.length > 0) {
      for (let item of res.data.records) {
        searchResult.value.push(item);
      }
    }

    isEmpty.value = !(res.data.records != null && res.data.records.length > 0);
  } catch (error) {
    searchResult.value = [];
    isEmpty.value = true;

    if (error.response != null && error.response.status === 401) {
      shouldLogin.value = true;
      isEmpty.value = false;
    }
  }
};

const setQuery = (
  keywordParam,
  startDateParam,
  endDateParam,
  pageParam,
  isOnlyOpenParam
) => {
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

  if (isOnlyOpenParam != null && isOnlyOpenParam === "true") {
    isOnlyOpen.value = true;
  } else {
    isOnlyOpen.value = false;
  }
};

const updatePaginateItems = function (pageParam) {
  page.value = pageParam;
  paramChange();
};

const startDateChange = (date) => {
  startDate.value = date;
}

const endDateChange = (date) => {
  endDate.value = date;
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
      <SearchButton @search-button-click="paramChange" />
    </div>
  </div>
  <div class="add-button-area">
    <button class="add-button p-2.5" @click="addRecord">
      + 記録を追加する
    </button>
  </div>
  <div class="py-8">
    <div v-if="searchResult.length > 0">
      <p class="text-center font-bold">合計{{ totalCount }}件</p>
      <div v-for="record in searchResult"  class="mt-5">
        <RecordCard :record="record" @record-click="clickRecord(record)" />
      </div>
      <div>
        <ListPage
          :pageCount="pageCount"
          v-model="page"
          @change-page="updatePaginateItems"
        />
      </div>
    </div>
    <div v-if="isEmpty">
      <ResultEmpty class="mx-5" />
    </div>
    <div v-if="shouldLogin">
      <LoginIntroductionView class="mx-5" />
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
