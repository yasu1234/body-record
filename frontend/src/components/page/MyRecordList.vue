<script setup>
import { ref, onMounted } from "vue";
import { useRouter, onBeforeRouteUpdate } from "vue-router";
import axios from "axios";
import Cookies from "js-cookie";

import ListPage from "../layout/ListPage.vue";
import DatePicker from "../atom/DatePicker.vue";
import SearchButton from "../atom/SearchButton.vue";
import RecordCard from "../layout/RecordCard.vue";

const router = useRouter();

const keyword = ref('');
const startDate = ref('');
const endDate = ref('');
const isDisplayOnlyOpen = ref(false);
const isLogin = ref(false);
const searchResult = ref([]);
const pageCount = ref(1);
const pageNum = ref(1);

onMounted(() => {
  search();
});

onBeforeRouteUpdate(async (to, from) => {
  if (to.query.keyword != null) {
    keyword.value = to.query.keyword;
  }
  if (to.query.startDate != null) {
    startDate.value = to.query.startDate;
  }
  if (to.query.endDate != null) {
    endDate.value = to.query.endDate;
  }
  if (to.query.page != null) {
    pageNum.value = to.query.page;
  } else {
    pageNum.value = 1;
  }
  
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
  <div class="my-record-search-container">
    <input
      type="text"
      id="keyword"
      name="keywordName"
      placeholder="キーワードで検索"
      v-model="keyword"
    />
    <div class="time-list">
      <div class="item">
        <p class="input-title">開始日</p>
        <DatePicker
          isStart="true"
          :date="startDate"
          @update:date="startDateChange"
        />
      </div>
      <div class="item">
        <p class="input-title">終了日</p>
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
.my-record-search-container {
  width: 700px;
  margin: 0 auto;
  padding: 20px;
  background-color: #ffffff;
  border: 1.5px solid #46c443;
  border-radius: 5px;
  margin-top: 20px;
}
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
@media screen and (max-width: 768px) {
  .my-record-search-container {
    width: auto;
    margin-left: 20px;
    margin-right: 20px;
    padding: 20px;
    background-color: #ffffff;
    border: 1px solid #46c443;
    border-radius: 5px;
    margin-top: 20px;
  }
}
</style>
