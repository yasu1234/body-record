<script setup>
import { ref, onMounted } from "vue";
import { useRouter, useRoute } from "vue-router";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../../js/toast.js";
import Toast from "primevue/toast";
import { axiosInstance, setupInterceptors } from "../../../js/axios.js";

import Header from "../../layout/Header.vue";
import RecordCard from "../../layout/RecordCard.vue";
import KnowledgeCard from "../../layout/KnowledgeCard.vue";
import Chart from "../../atom/Chart.vue";
import MonthPicker from "../../atom/MonthPicker.vue";
import Profile from "../../layout/Profile.vue";
import TabMenu from "../../layout/TabMenu.vue";

const route = useRoute();
const router = useRouter();
const toast = useToast();
const toastNotifications = new toastService(toast);
setupInterceptors(router);

const user = ref(null);
const support = ref(null);
const records = ref([]);
const knowledges = ref([]);
const isMoreRecords = ref(false);
const isMoreKnowledges = ref(false);
const userId = ref(0);
const month = ref({
  month: new Date().getMonth(),
  year: new Date().getFullYear(),
});

onMounted(() => {
  checkLogin();
});

var weigtData = ref({
  labels: [],
  datasets: [
    {
      label: "体重(kg)",
      data: [],
      borderColor: "rgb(75, 192, 192)",
    },
  ],
});

var fatPercentageData = ref({
  labels: [],
  datasets: [
    {
      label: "体脂肪率(%)",
      data: [],
      borderColor: "rgb(149, 101, 255)",
    },
  ],
});

const checkLogin = async () => {
  try {
    const res = await axiosInstance.get("/api/v1/users/check_login");
    userId.value = res.data.user.id;
    getProfile();
    getSupportCount();
    getUserRecord();
    getUserKnowledge();
    getMonthRecord();
  } catch (error) {
    toastNotifications.displayError("ユーザー情報を取得できません", "");
  }
};

const getProfile = async () => {
  try {
    const res = await axiosInstance.get(`/api/v1/profiles/${userId.value}`);

    user.value = res.data.user;
  } catch (error) {
    user.value = null;
    toastNotifications.displayError("プロフィールの取得に失敗しました", "");
  }
};

const getSupportCount = async () => {
  try {
    const res = await axiosInstance.get(`/api/v1/support_counts`, {
      params: {
        user_id: userId.value,
      },
    });

    support.value = res.data.user;
  } catch (error) {
    support.value = null;
  }
};

const getUserRecord = async () => {
  try {
    const res = await axiosInstance.get(`/api/v1/user_records`, {
      params: {
        user_id: userId.value,
      },
    });

    records.value = res.data.records;
    isMoreRecords.value = res.data.is_more;
  } catch (error) {
    records.value = [];
    isMoreRecords.value = false;
  }
};

const getMonthRecord = async () => {
  try {
    const res = await axiosInstance.get(`/api/v1/graph_records`, {
      params: {
        user_id: userId.value,
        targetYear: month.value.year,
        targetMonth: month.value.month + 1,
      },
    });

    weigtData.value.labels = res.data.records.map(
      (record) => record.graph_formatted_date
    );
    weigtData.value.datasets[0].data = res.data.records.map(
      (record) => record.weight
    );
    fatPercentageData.value.labels = res.data.records.map(
      (record) => record.graph_formatted_date
    );
    fatPercentageData.value.datasets[0].data = res.data.records.map(
      (record) => record.fat_percentage
    );
  } catch (error) {}
};

const getUserKnowledge = async () => {
  try {
    const res = await axiosInstance.get(`/api/v1/user_knowledges`, {
      params: {
        user_id: userId.value,
      },
    });

    knowledges.value = res.data.knowledges;
    isMoreKnowledges.value = res.data.is_more;
  } catch (error) {
    knowledges.value = [];
    isMoreKnowledges.value = false;
  }
};

function monthChange(event) {
  month.value = event;
  getMonthRecord();
}

const clickRecord = (item) => {
  router.push({ name: "RecordDetail", params: { id: item.id } });
};

const showMoreRecords = () => {
  router.push({ name: "Home" });
};
</script>

<template>
  <Toast position="top-center" />
  <Header />
  <TabMenu />
  <Profile :user="user" :support="support" />
  <div class="weight-graph">
    <Chart :data="weigtData" />
  </div>
  <div class="weight-graph">
    <Chart :data="fatPercentageData" />
  </div>
  <MonthPicker
    :date="month"
    @update:month="monthChange"
    class="graph-month-picker"
  />
  <div class="text-center">
    <div class="pt-10">
      <span class="section-title">投稿した記録</span>
    </div>
    <div class="mt-5">
      <RecordCard
        v-if="records.length > 0"
        v-for="record in records"
        v-bind="record"
        :record="record"
        @recordClick="clickRecord(record)"
      />
      <p v-else>登録された記録はありません</p>
    </div>
    <button
      v-if="isMoreRecords"
      @click="showMoreRecords"
      class="more-show-button mt-5"
    >
      もっと見る
    </button>
    <div class="pt-10">
      <span class="section-title">投稿した知識</span>
    </div>
    <div class="mt-5">
      <KnowledgeCard
        v-if="knowledges.length > 0"
        v-for="knowledge in knowledges"
        v-bind="knowledge"
        :knowledgeTitle="knowledge.title"
        :knowledgeContent="knowledge.content"
      />
      <p v-else>記事を作成していません</p>
    </div>
    <button
      v-if="isMoreKnowledges"
      @click="showMoreRecords"
      class="more-show-button mt-5"
    >
      もっと見る
    </button>
  </div>
</template>

<style scoped>
.section-title {
  border-bottom: solid 5px #ffa500;
  font-size: 25px;
  font-weight: bold;
}
.weight-graph {
  margin-top: 30px;
  width: 600px;
  margin-left: auto;
  margin-right: auto;
}
.graph-month-picker {
  margin-top: 20px;
  width: 600px;
  margin-left: auto;
  margin-right: auto;
}
.more-show-button {
  background: #fff;
  color: #000000;
  border: 1px solid #ccc;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  padding: 10px 50px;
}

@media screen and (max-width: 768px) {
  .weight-graph {
    width: auto;
    margin-left: 20px;
    margin-right: 20px;
    margin-top: 30px;
  }
  .graph-month-picker {
    margin-top: 20px;
    width: auto;
    margin-left: 20px;
    margin-right: 20px;
  }
}
</style>
