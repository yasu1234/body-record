<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../const/toast.js";
import axios from "axios";
import Cookies from "js-cookie";
import Textarea from "primevue/textarea";
import FloatLabel from "primevue/floatlabel";
import InputText from "primevue/inputtext";
import Toast from "primevue/toast";

import DatePicker from "../atom/DatePicker.vue";
import DropFile from "../atom/DropFile.vue";
import Header from "../layout/Header.vue";
import TabMenu from "../layout/TabMenu.vue";

const toast = useToast();
const toastNotifications = new toastService(toast);
const router = useRouter();

const memo = ref("");
const recordDate = ref("");
const weight = ref(null);
const fatPercentage = ref(null);
const files = ref([...Array(3)]);
const isAddAsHidden = ref(false);

function dateChange(event) {
  recordDate.value = event;
}

function onFileChange(event, index) {
  files.value[index - 1] = event;
}

const registerRecord = async () => {
  try {
    const formData = new FormData();
    formData.append("record[memo]", memo.value);
    formData.append("record[date]", recordDate.value);
    formData.append("record[weight]", weight.value);
    formData.append("record[fat_percentage]", fatPercentage.value);

    if (isAddAsHidden.value === false) {
      formData.append("record[open_status]", 1);
    }

    for (const file of files.value) {
      if (file != null) {
        formData.append("images", file);
      }
    }

    const res = await axios.post(
      import.meta.env.VITE_APP_API_BASE + "/api/v1/records",
      formData,
      {
        headers: {
          "Content-Type": "multipart/form-data",
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
      }
    );
    toastNotifications.displayInfo("登録しました", "");
    setTimeout(async () => {
      showRecordDetail(res.data.record);
    }, 3000);
  } catch (error) {
    let errorMessages = "";
    if (error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      }
    }
    toastNotifications.displayError("記録の追加に失敗しました", errorMessages);
  }
};

const showRecordDetail = (item) => {
  router.push({ name: "RecordDetail", params: { id: item.id } });
};
</script>

<template>
  <Header />
  <TabMenu />
  <Toast position="top-center" />
  <form class="add-record-container" @submit.prevent="registerRecord">
    <div class="record-add-space w-52">
      <p>記録日</p>
      <DatePicker
        isStart="false"
        :date="recordDate"
        @update:date="dateChange"
      />
    </div>
    <div class="input-group mt-7">
      <FloatLabel>
        <InputText v-model="weight" class="w-52 h-10 p-2.5" />
        <label>体重</label>
      </FloatLabel>
      <label for="goal-weight" class="unit-label">kg</label>
    </div>
    <div class="input-group mt-7">
      <FloatLabel>
        <InputText v-model="fatPercentage" class="w-52 h-10 p-2.5" />
        <label>体脂肪率</label>
      </FloatLabel>
      <label for="goal-fat-percentage" class="unit-label">%</label>
    </div>
    <div class="mt-7">
      <FloatLabel>
        <Textarea v-model="memo" rows="10" class="record-memo p-2.5" />
        <label>メモ</label>
      </FloatLabel>
    </div>
    <div class="mt-7">
      <input
        type="checkbox"
        id="statusSelect"
        v-model="isAddAsHidden"
        class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500"
      />
      <label for="statusSelectName">非公開記録にする場合にはチェック</label>
    </div>
    <div class="mt-7">
      <p>関連画像(3枚まで登録できます)</p>
      <div v-for="i in 3">
        <DropFile @change="onFileChange" :index="i" class="mt-3" />
      </div>
    </div>
    <div class="record-button-space mt-7">
      <button class="add-record-button">記録を登録する</button>
    </div>
  </form>
</template>

<style scoped>
.add-record-container {
  margin-top: 20px;
  margin-left: 30px;
}
.input-group {
  display: flex;
  align-items: center;
}
.record-button-space {
  padding-bottom: 20px;
}
.add-record-button {
  font-size: 16px;
  font-weight: bold;
  padding: 10px 50px;
  text-align: center;
}
.record-memo {
  width: 500px;
}
@media (max-width: 768px) {
  .record-memo {
    width: calc(100% - 20px);
  }
}
</style>
