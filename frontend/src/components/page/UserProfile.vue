<script setup>
import { ref, onMounted } from "vue";
import { useRouter, useRoute } from "vue-router";
import axios from "axios";
import Cookies from "js-cookie";

import Header from "../layout/Header.vue";
import RecordCard from "../layout/RecordCard.vue";
import KnowledgeCard from "../layout/KnowledgeCard.vue";
import Chart from "../atom/Chart.vue";
import MonthPicker from "../atom/MonthPicker.vue";
import Profile from "../layout/Profile.vue";

const route = useRoute();
const router = useRouter();

const records = ref([]);
const knowledges = ref([]);
const isLogin = ref(false);
const userId = ref(0);
const month = ref({
  month: new Date().getMonth(),
  year: new Date().getFullYear(),
});

onMounted(() => {
  userId.value = route.params.id;
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

const getUserRecord = async () => {
  try {
    const res = await axios.get(
      import.meta.env.VITE_APP_API_BASE + `/api/v1/records/user/${userId.value}`,
      {
        headers: {
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
      }
    );

    records.value = res.data.records;
  } catch (error) {
    if (error.response.status === 404) {
      showNotFound();
    }
  }
};

const getMonthRecord = async () => {
  try {
    const res = await axios.get(
      import.meta.env.VITE_APP_API_BASE + `/api/v1/graph_record`,
      {
        headers: {
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
        params: {
          user_id: userId.value,
          targetYear: month.value.year,
          targetMonth: month.value.month + 1,
        },
      }
    );

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
    if (error.response.status === 404) {
      showNotFound();
    }
  }
};

const getUserKnowledge = async () => {
  try {
    const res = await axios.get(
      import.meta.env.VITE_APP_API_BASE + `/api/v1/knowledges/user/${userId.value}`,
      {
        headers: {
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
      }
    );

    knowledges.value = res.data.knowledges;
  } catch (error) {
    knowledges.value = null
  }
};

function monthChange(event) {
  month.value = event;
  getMonthRecord();
}

function showEditProfile() {
  router.push({ name: "EditProfile", params: { id: userId.value } });
}

const showNotFound = () => {
  router.push({ name: "NotFound" });
};

const clickRecord = (item) => {
  router.push({ name: "RecordDetail", params: { id: item.id } });
};
</script>

<template>
  <Header />
  <Profile :userId="userId" />
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
  <div class="record-list">
    <span class="section-title">投稿した記録</span>
  </div>
  <RecordCard
    v-for="record in records"
    v-bind="record"
    :record="record"
    @recordClick="clickRecord(record)"
  />
  <div class="record-list">
    <span class="section-title">投稿した知識</span>
  </div>
  <KnowledgeCard
    v-for="knowledge in knowledges"
    v-bind="knowledge"
    :knowledgeTitle="knowledge.title"
    :knowledgeContent="knowledge.content"
  />
</template>

<style scoped>
.record-list {
  text-align: center;
  padding-top: 40px;
}
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
