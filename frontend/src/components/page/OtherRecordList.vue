<script setup>
import { ref, onMounted } from "vue";
import { useRouter, onBeforeRouteUpdate } from "vue-router";
import axios from "axios";
import Cookies from "js-cookie";

import TabMenu from "../layout/TabMenu.vue";
import Header from "../layout/Header.vue";
import ListPage from "../layout/ListPage.vue";
import DatePicker from "../atom/DatePicker.vue";
import RecordCard from "../layout/RecordCard.vue";
import SearchButton from "../atom/SearchButton.vue";

const router = useRouter();

const keyword = ref('');
const startDate = ref('');
const endDate = ref('');
const isDisplayOnlyOpen = ref(false);
const isLogin = ref(false);
const searchResult = ref([]);
const currentId = ref(2);

const pageCount = ref(1);
const page = ref(1);

onMounted(() => {
  search();
});

onBeforeRouteUpdate(async (to, from) => {
  keyword.value = to.query.keyword;
  startDate.value = to.query.startDate;
  endDate.value = to.query.endDate;
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

  router.push({ path: "/recordList", query: query });
};

const search = async () => {
  try {
    const res = await axios.get(
      import.meta.env.VITE_APP_API_BASE + "/api/v1/records",
      {
        headers: {
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },

        params: {
          keyword: keyword.value,
          startDate: startDate.value,
          endDate: endDate.value,
          page: page,
        },
      }
    );

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

const updatePaginateItems = function (pageNum) {
  page.value = pageNum;
  search();
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
</script>

<template>
  <Header />
  <TabMenu :currentId="currentId" />
  <div class="record-search-container">
    <input
      type="text"
      id="keyword"
      name="keywordName"
      placeholder="キーワードで検索"
      v-model="keyword"
    />
    <div class="time-list">
      <div class="item">
        <p class="inputTitle">開始日</p>
        <DatePicker
          isStart="true"
          :date="startDate"
          @update:date="startDateChange"
        />
      </div>
      <div class="item">
        <p class="inputTitle">終了日</p>
        <DatePicker
          isStart="false"
          :date="endDate"
          @update:date="endDateChange"
        />
      </div>
    </div>
    <div class="search-button-area">
      <SearchButton @searchButtonClick="searchParamChange" />
    </div>
  </div>
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
.time-list {
  display: flex;
}
.time-list .item {
  padding: 5px;
  box-sizing: border-box;
}
.time-list .item .inputTitle {
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
