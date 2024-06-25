<script setup>
import { ref, onMounted } from "vue";
import { useRouter, onBeforeRouteUpdate, useRoute } from "vue-router";
import { axiosInstance, setupInterceptors } from "../../../js/axios.js";

import TabMenu from "../../layout/TabMenu.vue";
import Header from "../../layout/Header.vue";
import ListPage from "../../layout/ListPage.vue";
import DatePicker from "../../atom/DatePicker.vue";
import RecordCard from "../../layout/RecordCard.vue";
import SearchButton from "../../atom/SearchButton.vue";
import ResultEmpty from "../../atom/ResultEmpty.vue";
import LoginIntroductionView from "../../layout/LoginIntroductionView.vue";

const router = useRouter();
const route = useRoute();
setupInterceptors(router);

const userId = ref(0);
const user = ref(null);
const keyword = ref("");
const startDate = ref("");
const endDate = ref("");
const shouldLogin = ref(false);
const searchResult = ref([]);
const currentId = ref(2);
const pageCount = ref(1);
const page = ref(1);
const isEmpty = ref(false);
const totalCount = ref(0);

onMounted(() => {
  userId.value = route.params.id;
  setQuery(
    route.query.keyword,
    route.query.startDate,
    route.query.endDate,
    route.query.page
  );
  getUser();
  search();
});

onBeforeRouteUpdate(async (to, from) => {
  setQuery(
    to.query.keyword,
    to.query.startDate,
    to.query.endDate,
    to.query.page
  );
  search();
});

const searchParamChange = () => {
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

  router.push({
    name: "OtherRecordList",
    params: { id: userId.value },
    query: query,
  });
};

const setQuery = (keywordParam, startDateParam, endDateParam, pageParam) => {
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
};

const getUser = async () => {
  try {
    const res = await axiosInstance.get(`/api/v1/users/${userId.value}`, {
      params: {
        keyword: keyword.value,
        startDate: startDate.value,
        endDate: endDate.value,
        page: page,
      },
    });

    user.value = res.data.user;
  } catch (error) {
    user.value = null;
  }
};

const search = async () => {
  shouldLogin.value = false;

  try {
    const res = await axiosInstance.get("/api/v1/records", {
      params: {
        user_id: userId.value,
        keyword: keyword.value,
        startDate: startDate.value,
        endDate: endDate.value,
        page: page,
      },
    });

    searchResult.value = [];

    if (res.data != null && res.data.total_page != null) {
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

const updatePaginateItems = (pageNum) => {
  page.value = pageNum;
  search();
};

const startDateChange = (event) => {
  startDate.value = event;
};

const endDateChange = (event) => {
  endDate.value = event;
};

const clickRecord = (item) => {
  router.push({ name: "RecordDetail", params: { id: item.id } });
};
</script>

<template>
  <Header />
  <TabMenu :currentId="currentId" />
  <div class="record-search-container">
    <p class="search-item-title font-bold" v-if="user != null">
      {{ user.name }}さんの記録検索
    </p>
    <input
      type="text"
      id="keyword"
      name="keywordName"
      placeholder="キーワードで検索"
      v-model="keyword"
    />
    <div class="record-search-time-list">
      <div class="item">
        <p class="search-item-title">検索開始日</p>
        <DatePicker
          isStart="true"
          :date="startDate"
          @update:date="startDateChange"
        />
      </div>
      <div class="item">
        <p class="search-item-title">検索終了日</p>
        <DatePicker
          isStart="false"
          :date="endDate"
          @update:date="endDateChange"
        />
      </div>
    </div>
    <div class="search-button-area">
      <SearchButton @search-button-click="searchParamChange" />
    </div>
  </div>
  <div class="py-8">
    <div v-if="searchResult.length > 0" class="mt-8">
      <p class="text-center font-bold">合計{{ totalCount }}件</p>
      <div v-for="record in searchResult" class="mt-5">
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
    <div div v-if="isEmpty">
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
  margin: 10px 0;
  box-sizing: border-box;
  border: 1px solid #ccc;
  border-radius: 4px;
}
.record-search-time-list .item {
  padding: 5px;
  box-sizing: border-box;
}
.record-search-time-list .item .search-item-title {
  margin: 5px 0 0;
  padding: 0;
  font-size: 16px;
}
.search-button-area {
  text-align: center;
  padding-top: 25px;
}
.search-button {
  font-size: 16px;
  font-weight: bold;
}
</style>
