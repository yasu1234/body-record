<script setup>
import { ref, onMounted } from "vue";
import { useRouter, onBeforeRouteUpdate, useRoute } from "vue-router";
import axios from "axios";
import Cookies from "js-cookie";

import ListPage from "../layout/ListPage.vue";
import DatePicker from "../atom/DatePicker.vue";
import SearchButton from "../atom/SearchButton.vue";
import RecordCard from "../layout/RecordCard.vue";

const router = useRouter();
const route = useRoute();

const keyword = ref("");
const startDate = ref("");
const endDate = ref("");
const isDisplayOnlyOpen = ref(false);
const isLogin = ref(false);
const searchResult = ref([]);
const pageCount = ref(1);
const pageNum = ref(1);

onMounted(() => {
  setQuery(
    route.query.keyword,
    route.query.startDate,
    route.query.endDate,
    route.query.page
  );
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

  if (pageNum.value > 1) {
    query.page = pageNum.value;
  }

  router.push({ path: "/", query: query });
};

const search = async () => {
  try {
    const res = await axios.get(
      import.meta.env.VITE_APP_API_BASE + "/api/v1/myRecord",
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
          page: pageNum.value,
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

const setQuery = (keywordParam, startDateParam, endDateParam, pageParam) => {
  if (keywordParam != null) {
    keyword.value = keywordParam;
  } else {
    keyword.value = '';
  }
  if (startDateParam != null) {
    startDate.value = startDateParam;
  } else {
    startDate.value = '';
  }
  if (endDateParam != null) {
    endDate.value = endDateParam;
  } else {
    endDate.value = '';
  }
  if (pageParam != null) {
    pageNum.value = pageParam;
  } else {
    pageNum.value = 1;
  }
};

const updatePaginateItems = function (page) {
  pageNum.value = page;
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

function addRecord() {
  router.push("/addRecord");
}
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
    <div class="time-list">
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
        v-model="isDisplayOnlyOpen"
        class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500"
      />
      <label>非公開記録は表示しない</label>
    </div>
    <div class="search-button-area">
      <SearchButton @searchButtonClick="paramChange" />
    </div>
  </div>
  <div class="add-button-area">
    <button class="add-button" @click="addRecord">記録を追加する</button>
  </div>
  <div class="mt-5">
    <RecordCard
      v-for="record in searchResult"
      v-bind="record"
      :record="record"
      @recordClick="clickRecord(record)"
    />
  </div>
  <div class="mt-12">
    <ListPage
      :pageCount="pageCount"
      v-model="pageNum"
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
.time-list .item {
  padding: 5px;
  box-sizing: border-box;
}
.time-list .item .input-title {
  margin: 5px 0 0;
  padding: 0;
  font-size: 16px;
}
.search-button-area {
  text-align: center;
  margin-top: 20px;
}
.add-button-area {
  text-align: right;
  margin-top: 20px;
  padding-right: 40px;
}
.add-button {
  font-size: 16px;
  font-weight: bold;
}

@media screen and (min-width: 768px) {
  .time-list {
    display: flex;
  }
}
</style>
