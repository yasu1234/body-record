<script setup>
import { ref, onMounted } from "vue";
import { useRouter, onBeforeRouteUpdate } from "vue-router";
import axios from "axios";
import Cookies from "js-cookie";

import TabMenu from "../layout/TabMenu.vue";
import Header from "../layout/Header.vue";
import UserCard from "../layout/UserCard.vue";
import ListPage from "../layout/ListPage.vue";
import SearchButton from "../atom/SearchButton.vue";

const router = useRouter();

const keyword = ref('');
const isDisplayOnlySupport = ref(false);
const isLogin = ref(false);
const searchResult = ref([]);

const pageCount = ref(1);
const pageNum = ref(1);

onMounted(() => {
  searchUser();
});

onBeforeRouteUpdate(async (to, from) => {
  keyword.value = to.query.keyword;
  searchUser();
});

const targetSearch = () => {
  const query = {};

  if (keyword.value.trim() !== "") {
    query.keyword = keyword.value;
  }

  router.push({ path: "/users", query: query });
};

const searchUser = async () => {
  try {
    const res = await axios.get(
      import.meta.env.VITE_APP_API_BASE + "/api/v1/users",
      {
        headers: {
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
        params: {
          keyword: keyword.value,
          page: pageNum,
        },
      }
    );

    if (res.data && res.data.total_page) {
      pageCount.value = res.data.total_page;
    } else {
      pageCount.value = 1;
    }

    searchResult.value = [];

    for (let item of res.data.users) {
      searchResult.value.push(item);
    }
  } catch (error) {
    searchResult.value = [];
  }
};

const updatePaginateItems = function (page) {
  pageNum.value = page;
  searchUser();
};

const userSelect = (item) => {
  router.push({ name: "OtherRecordList", params: { id: item.id } });
};
</script>

<template>
  <Header />
  <TabMenu :currentId="2" />
  <div class="user-search-container">
    <input
      type="text"
      id="keyword"
      name="keywordName"
      placeholder="名前で検索"
      v-model="keyword"
    />
    <div class="search-check">
      <input type="checkbox" id="statusSelect" v-model="isDisplayOnlySupport" />
      <label>応援しているユーザーのみ表示</label>
    </div>
    <div class="search-button-area">
      <SearchButton @searchButtonClick="targetSearch" />
    </div>
  </div>
  <div class="user-search-result">
    <div
      v-for="user in searchResult"
      class="user-card"
      @click="userSelect(user)"
    >
      <UserCard :user="user" />
    </div>
  </div>
  <div class="user-list-page">
    <ListPage
      :pageCount="pageCount"
      v-model="pageNum"
      @changePage="updatePaginateItems"
    />
  </div>
</template>

<style scoped>
.user-search-container {
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

input[type="checkbox"] {
  border-radius: 0;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
}
input[type="checkbox"] {
  position: relative;
  width: 16px;
  height: 16px;
  border: 1px solid #000;
  vertical-align: -5px;
}

input[type="checkbox"]:checked:before {
  position: absolute;
  top: 1px;
  left: 4px;
  transform: rotate(50deg);
  width: 4px;
  height: 8px;
  border-right: 2px solid #000;
  border-bottom: 2px solid #000;
  content: "";
}
.search-check {
  margin-top: 20px;
}
.user-search-result {
  margin-top: 20px;
}
.search-button-area {
  text-align: center;
  margin-top: 20px;
}
.user-card {
  width: 100%;
  max-width: 600px;
  margin: 0 auto;
  margin-bottom: 20px;
  margin-top: 10px;
  position: relative;
  box-shadow: 0px 1px 3px rgba(0, 0, 0, 0.18);
  border: 1px solid #ccc;
  border-radius: 5px;
  background-color: #ffffff;
  cursor: pointer;
}
.user-list-page {
  margin-top: 50px;
}
@media screen and (max-width: 768px) {
  .user-search-container {
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
