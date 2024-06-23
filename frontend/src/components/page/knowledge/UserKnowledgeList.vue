<template>
  <Header />
  <TabMenu />
  <Toast position="top-center" />
  <div class="mt-5 p-2.5 text-center">
    <P class="font-bold">{{ userName }}さんの記事一覧</P>
    <div v-if="knowledgeList.length > 0">
      <div v-for="knowledge in knowledgeList">
        <KnowledgeCard
          :knowledge="knowledge"
          @click="clickKnowledge(knowledge)"
        />
      </div>
      <div class="mt-12">
        <ListPage
          :pageCount="pageCount"
          v-model="pageNum"
          @changePage="updatePaginateItems"
        />
      </div>
    </div>
    <div v-else>
      <p class="mx-5 mt-5">投稿された記事はありません</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRouter, useRoute } from "vue-router";
import { axiosInstance, setupInterceptors } from "../../../js/axios.js";
import Toast from "primevue/toast";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../../js/toast.js";

import TabMenu from "../../layout/TabMenu.vue";
import Header from "../../layout/Header.vue";
import KnowledgeCard from "../../layout/KnowledgeCard.vue";
import ListPage from "../../layout/ListPage.vue";

const route = useRoute();
const router = useRouter();
setupInterceptors(router);
const toast = useToast();
const toastNotifications = new toastService(toast);

const userId = ref(0);
const userName = ref("");
const knowledgeList = ref([]);
const pageCount = ref(1);
const pageNum = ref(1);

onMounted(() => {
  userId.value = route.params.id;
  getUserKnowledge();
  getUser();
});

const getUserKnowledge = async () => {
  try {
    const res = await axiosInstance.get(`/api/v1/knowledges`, {
      params: {
        user_id: userId.value,
        page: pageNum.value
      },
    });

    knowledgeList.value = [];

    if (res.data.knowledges != null) {
      for (let item of res.data.knowledges) {
        knowledgeList.value.push(item);
      }
    }
  } catch (error) {
    let message = "";

    if (error.response != null && error.response.status === 401) {
      message = "ログインしてください";
    }

    toastNotifications.displayError(
      "記事一覧の取得に失敗しました",
      message
    );
  }
};

const getUser = async () => {
  try {
    const res = await axiosInstance.get(`/api/v1/users/${userId.value}`);

    userName.value = res.data.user.name;
  } catch (error) {
    let message = "";

    if (error.response != null && error.response.status === 401) {
      message = "ログインしてください";
    }

    toastNotifications.displayError(
      "ユーザー情報取得に失敗しました",
      message
    );
  }
};

const updatePaginateItems = (page) => {
  pageNum.value = page;
  searchUser();
};
</script>

<style scoped>


@media screen and (max-width: 768px) {
}
</style>
