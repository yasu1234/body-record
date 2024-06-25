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
      <SearchButton @search-button-click="targetSearch" />
    </div>
  </div>
  <div class="add-button-area">
    <button class="add-button p-2.5" @click="addKnowledge">
      + 記事を追加する
    </button>
  </div>
  <div class="py-8">
    <div v-if="searchResult.length > 0">
      <div class="select-box">
        <div
          v-for="menu in menuList"
          :key="menu.code"
          class="text-sm rounded-lg block p-3"
        >
          <RadioButton
            v-model="selectCode"
            :inputId="String(menu.code)"
            :value="menu.name"
            @update:model-value="changeSortType"
            :pt="{
              root: {
                style: {
                  border: '1px solid #000',
                  height: '100%',
                },
              },
            }"
          />
          <label :for="menu.key" class="ml-2">{{ menu.name }}</label>
        </div>
      </div>
      <p class="text-center font-bold mt-8">合計{{ totalCount }}件</p>
      <KnowledgeCard
        v-for="knowledge in searchResult"
        :knowledge="knowledge"
        @click="clickKnowledge(knowledge)"
      />
      <div class="mt-12 pb-8">
        <ListPage
          :pageCount="pageCount"
          v-model="pageNum"
          @change-page="updatePaginateItems"
        />
      </div>
    </div>
    <div v-if="isEmpty">
      <ResultEmpty class="mx-5 mt-5" />
    </div>
    <div v-if="shouldLogin">
      <LoginIntroductionView class="mx-5" />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRouter, useRoute, onBeforeRouteUpdate } from "vue-router";
import { axiosInstance, setupInterceptors } from "../../../js/axios.js";
import { KnowledgeListSortType } from "../../../js/const.js";
import RadioButton from "primevue/radiobutton";

import TabMenu from "../../layout/TabMenu.vue";
import Header from "../../layout/Header.vue";
import ListPage from "../../layout/ListPage.vue";
import SearchButton from "../../atom/SearchButton.vue";
import KnowledgeCard from "../../layout/KnowledgeCard.vue";
import ResultEmpty from "../../atom/ResultEmpty.vue";
import LoginIntroductionView from "../../layout/LoginIntroductionView.vue";

const route = useRoute();
const router = useRouter();
setupInterceptors(router);

const keyword = ref("");
const isBookmark = ref(false);
const searchResult = ref([]);
const pageCount = ref(1);
const pageNum = ref(1);
const isShowMine = ref(false);
const shouldLogin = ref(false);
const isEmpty = ref(false);
const menuList = ref(KnowledgeListSortType);
const selectCode = ref(menuList.value[0].name);
const totalCount = ref(0);

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
  shouldLogin.value = false;

  try {
    const res = await axiosInstance.get("/api/v1/knowledges", {
      params: {
        keyword: keyword.value,
        is_bookmark: isBookmark.value,
        is_show_mine: isShowMine.value,
        page: pageNum.value,
        sort_type:
          selectCode.value === menuList.value[1].name
            ? menuList.value[1].code
            : menuList.value[0].code,
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

    if (res.data.knowledges != null && res.data.knowledges.length > 0) {
      for (let item of res.data.knowledges) {
        searchResult.value.push(item);
      }
    }

    isEmpty.value = !(
      res.data.knowledges != null && res.data.knowledges.length > 0
    );
  } catch (error) {
    searchResult.value = [];
    if (error.response != null && error.response.status === 401) {
      shouldLogin.value = true;
    }
  }
};

const updatePaginateItems = function (pageNum) {
  pageNum.value = pageNum;
  search();
};

const changeSortType = (event) => {
  if (event == null) {
    return;
  }
  selectCode.value = event;
  search();
};

const clickKnowledge = (item) => {
  router.push({ name: "KnowledgeDetail", params: { id: item.id } });
};

const addKnowledge = () => {
  router.push("AddKnowledge");
};
</script>

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
.select-box {
  width: 280px;
  border: 1px solid #ccc;
  margin: 0 auto;
}
:deep(thead) {
  background: #ccc;
  border: 1px solid #ddd;
}
:deep(code) {
  background: #ccc;
  white-space: pre-wrap;
}
:deep(td) {
  border: 1px solid #000;
}
:deep(th) {
  border: 1px solid #000;
}
:deep(ul) {
  list-style-type: disc;
}
:deep(ol) {
  list-style-type: decimal;
}
:deep(h1) {
  text-decoration: underline;
}
:deep(h2) {
  text-decoration: underline;
}
:deep(h3) {
  text-decoration: underline;
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
