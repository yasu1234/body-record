<script setup>
import { ref, onMounted } from "vue";
import { useRouter, useRoute, onBeforeRouteUpdate } from "vue-router";
import { axiosInstance, setupInterceptors } from "../../../js/axios.js";

import TabMenu from "../../layout/TabMenu.vue";
import Header from "../../layout/Header.vue";
import ListPage from "../../layout/ListPage.vue";
import SearchButton from "../../atom/SearchButton.vue";
import KnowledgeCard from "../../layout/KnowledgeCard.vue";
import ResultEmpty from "../../atom/ResultEmpty.vue";

const route = useRoute();
const router = useRouter();
setupInterceptors(router);

const keyword = ref("");
const isBookmark = ref(false);
const searchResult = ref([]);
const pageCount = ref(1);
const pageNum = ref(1);
const isShowMine = ref(false);
const isLogin = ref(false);

onMounted(() => {
  setQuery(route.query.keyword, route.query.isBookmark, route.query.isShowMine);
  search();
});

onBeforeRouteUpdate(async (to, from) => {
  setQuery(to.query.keyword, to.query.isBookmark, to.query.isShowMine);

  search();
});

const setQuery = (keywordParam, bookmarkParam, showMineParam) => {
  if (keywordParam != null) {
    keyword.value = keywordParam;
  } else {
    keyword.value = "";
  }

  if (bookmarkParam != null && bookmarkParam === "true") {
    isBookmark.value = true;
  } else {
    isBookmark.value = false;
  }

  if (showMineParam != null && showMineParam === "true") {
    isShowMine.value = true;
  } else {
    isShowMine.value = false;
  }
};

const targetSearch = () => {
  const query = {};

  if (keyword.value.trim() !== "") {
    query.keyword = keyword.value;
  }

  if (isBookmark.value === true) {
    query.isBookmark = true;
  }

  if (isShowMine.value === true) {
    query.isShowMine = true;
  }

  router.push({ name: "KnowledgeList", query: query });
};

const search = async () => {
  try {
    const res = await axiosInstance.get("/api/v1/knowledges", {
      params: {
        keyword: keyword.value,
        is_bookmark: isBookmark.value,
        is_show_mine: isShowMine.value,
        page: pageNum.value
      },
    });

    if (res.data && res.data.totalPage) {
      pageCount.value = res.data.totalPage;
    } else {
      pageCount.value = 1;
    }

    searchResult.value = [];

    for (let item of res.data.knowledges) {
      searchResult.value.push(item);
    }
    isLogin.value = false;
  } catch (error) {
    searchResult.value = [];
    isLogin.value = false;
    if (error.response != null && error.response.status === 401) {
      isLogin.value = true;
    }
  }
};

const updatePaginateItems = function (pageNum) {
  pageNum.value = pageNum;
  search();
};

const clickKnowledge = (item) => {
  router.push({ name: "KnowledgeDetail", params: { id: item.id } });
};

const addKnowledge = () => {
  router.push("AddKnowledge");
};
</script>

<template>
  <Header />
  <TabMenu :currentId="3" />
  <div class="knowledge-search-container">
    <div class="mt-5">
      <input
        type="text"
        id="keyword"
        name="keywordName"
        placeholder="キーワードで絞り込む"
        v-model="keyword"
      />
    </div>
    <div class="mt-5 pr-3">
      <input
        type="checkbox"
        v-model="isBookmark"
        class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500"
      />
      <label class="ml-2">ブックマークのみ絞り込む</label>
    </div>
    <div class="mt-5 pr-3">
      <input
        type="checkbox"
        v-model="isShowMine"
        class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500"
      />
      <label class="ml-2">自分が作成した記事のみ表示</label>
    </div>
    <div class="text-center mt-5">
      <SearchButton @searchButtonClick="targetSearch" />
    </div>
  </div>
  <div class="add-button-area">
    <button class="add-button p-2.5" @click="addKnowledge">
      + ノウハウ記事を追加する
    </button>
  </div>
  <div v-if="searchResult.length > 0">
    <KnowledgeCard
      v-for="knowledge in searchResult"
      v-bind="knowledge"
      :knowledge="knowledge"
      @click="clickKnowledge(knowledge)"
    />
    <div class="mt-12 pb-8">
      <ListPage
        :pageCount="pageCount"
        v-model="pageNum"
        @changePage="updatePaginateItems"
      />
    </div>
  </div>
  <div v-else>
    <ResultEmpty class="mx-5 mt-5" />
  </div>
</template>

<style scoped>
.knowledge-search-container {
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
.add-button {
  font-size: 16px;
  font-weight: bold;
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
  .knowledge-search-container {
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
