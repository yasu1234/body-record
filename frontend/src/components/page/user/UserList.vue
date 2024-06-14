<script setup>
import { ref, onMounted } from "vue";
import { useRouter, useRoute, onBeforeRouteUpdate } from "vue-router";
import { axiosInstance, setupInterceptors } from "../../../js/axios.js";

import TabMenu from "../../layout/TabMenu.vue";
import Header from "../../layout/Header.vue";
import UserCard from "../../layout/UserCard.vue";
import ListPage from "../../layout/ListPage.vue";
import SearchButton from "../../atom/SearchButton.vue";
import ResultEmpty from "../../atom/ResultEmpty.vue";

const route = useRoute();
const router = useRouter();
setupInterceptors(router);

const keyword = ref("");
const isDisplayOnlySupport = ref(false);
const isLogin = ref(false);
const searchResult = ref([]);
const pageCount = ref(1);
const page = ref(1);

onMounted(() => {
  setQuery(route.query.keyword, route.query.onlySupport, route.query.page);
  searchUser();
});

onBeforeRouteUpdate(async (to, from) => {
  setQuery(to.query.keyword, to.query.onlySupport, to.query.page);
  searchUser();
});

const targetSearch = () => {
  const query = {};

  if (keyword.value.trim() !== "") {
    query.keyword = keyword.value;
  }

  if (isDisplayOnlySupport.value) {
    query.onlySupport = true;
  }

  router.push({ path: "/users", query: query });
};

const setQuery = (keywordParam, onlySupportParam, pageParam) => {
  if (keywordParam != null) {
    keyword.value = keywordParam;
  } else {
    keyword.value = "";
  }
  if (onlySupportParam != null && onlySupportParam) {
    isDisplayOnlySupport.value = true;
  } else {
    isDisplayOnlySupport.value = false;
  }
  if (pageParam != null) {
    page.value = pageParam;
  } else {
    page.value = 1;
  }
};

const searchUser = async () => {
  try {
    const res = await axiosInstance.get("/api/v1/users", {
      params: {
        keyword: keyword.value,
        page: page.value,
        isSupportOnly: isDisplayOnlySupport.value,
      },
    });

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
  router.push({ name: "OtherRecordList", params: { id: item.user.id } });
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
    <div class="mt-5">
      <input
        type="checkbox"
        id="statusSelect"
        v-model="isDisplayOnlySupport"
        class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500"
      />
      <label class="ml-2.5">応援しているユーザーのみ表示</label>
    </div>
    <div class="search-button-area">
      <SearchButton @searchButtonClick="targetSearch" />
    </div>
  </div>
  <div class="mt-5 pb-5">
    <div v-if="searchResult.length > 0">
      <div
        v-for="user in searchResult"
        class="user-card"
        @click="userSelect(user)"
      >
        <UserCard :user="user" />
      </div>
      <div class="mt-12">
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
  .user-card {
    width: auto;
    margin-left: 20px;
    margin-right: 20px;
  }
}
</style>
