<script setup>
import { ref, onMounted } from "vue";
import { useRouter, useRoute } from "vue-router";
import { axiosInstance, setupInterceptors } from "../../../js/axios.js";
import Toast from "primevue/toast";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../../js/toast.js";

import TabMenu from "../../layout/TabMenu.vue";
import Header from "../../layout/Header.vue";
import SupportCard from "../../layout/SupportCard.vue";
import ListPage from "../../layout/ListPage.vue";

const route = useRoute();
const router = useRouter();
setupInterceptors(router);
const toast = useToast();
const toastNotifications = new toastService(toast);

const userId = ref(0);
const user = ref(null);
const isLogin = ref(false);
const supporterList = ref([]);
const pageCount = ref(1);
const pageNum = ref(1);

onMounted(() => {
  userId.value = route.params.id;
  getSupporter();
});

const getSupporter = async () => {
  try {
    const res = await axiosInstance.get(`/api/v1/supports`, {
      params: {
        user_id: userId.value,
        is_support: false,
      },
    });

    supporterList.value = [];

    if (res.data.user.support != null) {
      for (let item of res.data.user.support) {
        supporterList.value.push(item);
      }
    }

    user.value = res.data.user.support;
  } catch (error) {
    toastNotifications.displayError(
      "サポーターの取得に失敗しました",
      ""
    );
  }
};

const supportOff = async (userId) => {
  try {
    const res = await axiosInstance.delete(`/api/v1/supports/${userId}`);
    getSupporter();
  } catch (error) {
    let errorMessages = "";
    if (error.response != null && error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      } else {
        errorMessages = error.response.data.errors;
      }
    }
    toastNotifications.displayError(
      "応援解除に失敗しました",
      errorMessages
    );
  }
};

const supportOn = async (userId) => {
  try {
    const formData = new FormData();
    formData.append("id", userId);

    const res = await axiosInstance.post(`/api/v1/supports`, formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });
    getSupporter();
  } catch (error) {
    let errorMessages = "";
    if (error.response != null && error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      } else {
        errorMessages = error.response.data.errors;
      }
    }
    toastNotifications.displayError("応援に失敗しました", errorMessages);
  }
};

const updatePaginateItems = function (page) {
  pageNum.value = page;
  searchUser();
};
</script>

<template>
  <Header />
  <TabMenu />
  <Toast position="top-center" />
  <div class="mt-5 p-2.5 text-center">
    <P class="font-bold">サポーター(応援しているユーザー)一覧</P>
    <div v-if="supporterList.length > 0">
      <div
        v-for="supporter in supporterList"
        class="support-card"
      >
        <SupportCard
          :user="supporter"
          :isSupport="supporter.is_support_mine"
          @support-off="supportOff"
          @support-on="supportOn"
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
      <p class="mx-5 mt-5">サポーターはいません</p>
    </div>
  </div>
</template>

<style scoped>
.support-card {
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
  .support-card {
    width: auto;
    margin-left: 20px;
    margin-right: 20px;
  }
}
</style>
