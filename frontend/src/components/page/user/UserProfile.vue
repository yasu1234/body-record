<template>
  <Toast position="top-center" />
  <Header />
  <TabMenu />
  <Profile :user="user" :support="support" @edit-support="editSupport" />
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
  <div class="text-center pb-8">
    <div class="pt-10">
      <span class="section-title">作成した記録</span>
    </div>
    <div class="mt-5">
      <div v-if="records.length > 0" v-for="record in records">
        <RecordCard :record="record" @record-click="clickRecord(record)" />
      </div>
      <p v-else>作成された記録はありません</p>
    </div>
    <button
      v-if="isMoreRecords"
      @click="showMoreRecords"
      class="more-show-button mt-5"
    >
      もっと見る
    </button>
    <div class="pt-10">
      <span class="section-title">投稿した記事</span>
    </div>
    <div class="mt-5">
      <div v-if="knowledges.length > 0" v-for="knowledge in knowledges">
        <KnowledgeCard
          :knowledge="knowledge"
          @click="clickKnowledge(knowledge)"
        />
      </div>
      <p v-else>記事を作成していません</p>
    </div>
    <button
      v-if="isMoreKnowledges"
      @click="showMoreKnowledges"
      class="more-show-button mt-5"
    >
      もっと見る
    </button>
  </div>
</template>

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
  userId.value = route.params.id;
  getProfile();
  getSupportCount();
  getUserRecord();
  getUserKnowledge();
  getMonthRecord();
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

const getProfile = async () => {
  try {
    const res = await axiosInstance.get(`/api/v1/profiles/${userId.value}`);

    user.value = res.data.user;
  } catch (error) {
    if (error.response != null && error.response.status === 401) {
      toastNotifications.displayError("ログインしてください", "");
    } else {
      user.value = null;
    }
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
    if (error.response != null && error.response.status === 401) {
      toastNotifications.displayError("ログインしてください", "");
    }
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

    if (error.response != null && error.response.status === 401) {
      toastNotifications.displayError("ログインしてください", "");
    }
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
  } catch (error) {
    weigtData.value.labels = [];
    weigtData.value.datasets[0].data = [];
    fatPercentageData.value.labels = [];
    fatPercentageData.value.datasets[0].data = [];

    if (error.response != null && error.response.status === 401) {
      toastNotifications.displayError("ログインしてください", "");
    }
  }
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

    if (error.response != null && error.response.status === 401) {
      toastNotifications.displayError("ログインしてください", "");
    }
  }
};

const supportOn = async () => {
  try {
    const formData = new FormData();
    formData.append("id", userId.value);

    const res = await axiosInstance.post(`/api/v1/supports`, formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });
    support.value = res.data.user;
  } catch (error) {
    let errorMessages = "";

    if (error.response != null) {
      if (error.response.status === 401) {
        toastNotifications.displayError("ログインしてください", "");
        return;
      }
      if (error.response.status === 422) {
        if (Array.isArray(error.response.data.errors)) {
          errorMessages += error.response.data.errors.join("\n");
        } else {
          errorMessages = error.response.data.errors;
        }
      }
    }

    toastNotifications.displayError(
      "サポート登録に失敗しました",
      errorMessages
    );
  }
};

const supportOff = async () => {
  try {
    const res = await axiosInstance.delete(`/api/v1/supports/${userId.value}`);
    support.value = res.data.user;
  } catch (error) {
    let errorMessages = "";

    if (error.response != null) {
      if (error.response.status === 401) {
        toastNotifications.displayError("ログインしてください", "");
        return;
      }
      if (error.response.status === 422) {
        if (Array.isArray(error.response.data.errors)) {
          errorMessages += error.response.data.errors.join("\n");
        } else {
          errorMessages = error.response.data.errors;
        }
      }
    }

    toastNotifications.displayError("サポート解除に失敗しました", errorMessage);
  }
};

const monthChange = (event) => {
  month.value = event;
  getMonthRecord();
};

const editSupport = (isSupport) => {
  if (isSupport) {
    supportOff();
  } else {
    supportOn();
  }
};

const clickRecord = (item) => {
  router.push({ name: "RecordDetail", params: { id: item.id } });
};

const showMoreRecords = () => {
  router.push({ name: "OtherRecordList", params: { id: userId.value } });
};

const clickKnowledge = (item) => {
  router.push({ name: "KnowledgeDetail", params: { id: item.id } });
};

const showMoreKnowledges = () => {
  router.push({ name: "UserKnowledgeList", params: { id: userId.value } });
};
</script>

<style scoped>
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
