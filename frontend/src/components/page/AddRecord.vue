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

const memo = ref("");
const recordDate = ref("");
const weight = ref(null);
const fatPercentage = ref(null);
const files = ref([]);
const isAddAsHidden = ref(false);
const toast = useToast();
const toastNotifications = new toastService(toast);
const router = useRouter();

function dateChange(event) {
  recordDate.value = event;
}

function onFileChange(event) {
  files.value = [...event];
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
      formData.append("images", file);
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
}
</script>

<template>
  <Header />
  <Toast position="top-center" />
  <div class="add-record-container">
    <div class="record-add-space">
      <p>記録日</p>
      <DatePicker
        isStart="false"
        :date="recordDate"
        @update:date="dateChange"
        class="input-width"
      />
    </div>
    <div class="record-add-space input-group">
      <FloatLabel>
        <InputText v-model="weight" class="input-width" />
        <label>体重</label>
      </FloatLabel>
      <label for="goal-weight" class="unit-label">kg</label>
    </div>
    <div class="record-add-space input-group">
      <FloatLabel>
        <InputText v-model="fatPercentage" class="input-width" />
        <label>体脂肪率</label>
      </FloatLabel>
      <label for="goal-fat-percentage" class="unit-label">%</label>
    </div>
    <div class="record-add-space">
      <FloatLabel>
        <Textarea v-model="memo" rows="10" />
        <label>メモ</label>
      </FloatLabel>
    </div>
    <div class="record-add-space">
      <input type="checkbox" id="statusSelect" v-model="isAddAsHidden" />
      <label for="statusSelectName">非公開記録にする場合にはチェック</label>
    </div>
    <div class="record-add-space">
      <p>関連画像</p>
      <DropFile @change="onFileChange" />
    </div>
  </div>
  <div class="record-add-space">
    <button class="add-record-button" @click="registerRecord">
      記録を登録する
    </button>
  </div>
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
.input-width {
  width: 200px;
}
.record-add-space {
  margin-top: 30px;
}
.add-record-button {
  font-size: 16px;
  font-weight: bold;
  padding: 10px 50px;
}
</style>
