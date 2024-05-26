<script setup>
import { ref, onMounted } from "vue";
import { useRouter, onBeforeRouteUpdate } from "vue-router";
import axios from "axios";
import Cookies from "js-cookie";

import TabMenu from "../layout/TabMenu.vue";
import Header from "../layout/Header.vue";
import ListPage from "../layout/ListPage.vue";
import SearchButton from "../atom/SearchButton.vue";
import KnowledgeCard from "../layout/KnowledgeCard.vue";

const router = useRouter();

const keyword = ref('');
const isBookmark = ref(false);
const isLogin = ref(false);
const searchResult = ref([]);

const currentId = ref(3);
const pageCount = ref(1);
const pageNum = ref(1);

onMounted(() => {
  search();
});

onBeforeRouteUpdate(async (to, from) => {
  keyword.value = to.query.keyword;
  search();
});

const targetSearch = () => {
  const query = {};

  if (keyword.value.trim() !== "") {
    query.keyword = keyword.value;
  }

  if (isBookmark.value === true) {
    query.startDate = startDate.value;
  }

  router.push({ name: "KnowledgeList", query: query });
};

const search = async () => {
  try {
    const res = await axios.get(
      import.meta.env.VITE_APP_API_BASE + "/api/v1/knowledges",
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

    if (res.data && res.data.totalPage) {
      pageCount.value = res.data.totalPage;
    } else {
      pageCount.value = 1;
    }

    searchResult.value = [];

    for (let item of res.data.knowledges) {
      searchResult.value.push(item);
    }
  } catch (error) {
    searchResult.value = [];
  }
};

const updatePaginateItems = function (pageNum) {
  pageNum.value = pageNum;
  search();
};

function clickKnowledge(item) {
  router.push({ name: "KnowledgeDetail", params: { id: item.id } });
}

function addKnowledge() {
  router.push("/addKnowledge");
}
</script>

<template>
  <Header />
  <TabMenu :currentId="currentId" />
  <div class="knowledge-search-container">
    <div class="keyword-search">
      <input
        type="text"
        id="keyword"
        name="keywordName"
        placeholder="キーワードで絞り込む"
        v-model="keyword"
      />
    </div>
    <div class="search-check">
      <input
        type="checkbox"
        id="statusSelect"
        v-model="isBookmark"
        class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500"
      />
      <label for="statusSelectName">ブックマークのみ絞り込む</label>
    </div>
    <div class="search-button-area">
      <SearchButton @searchButtonClick="targetSearch" />
    </div>
  </div>
  <div class="add-button-area">
    <button class="add-button" @click="addKnowledge">ノウハウを追加する</button>
  </div>
  <KnowledgeCard
    v-for="knowledge in searchResult"
    v-bind="knowledge"
    :knowledgeTitle="knowledge.title"
    :knowledgeContent="knowledge.content"
    @click="clickKnowledge(knowledge)"
  />
  <div class="mt-12">
    <ListPage
      :pageCount="pageCount"
      v-model="pageNum"
      @changePage="updatePaginateItems"
    />
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
.keyword-search {
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
.search-check {
  margin-top: 20px;
  padding-left: 20px;
  padding-right: 20px;
}
.search-button-area {
  text-align: center;
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
</style>
