<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../const/toast.js";
import Textarea from "primevue/textarea";
import FloatLabel from "primevue/floatlabel";
import InputText from "primevue/inputtext";
import Toast from "primevue/toast";
import { axiosInstance, setupInterceptors } from "../../const/axios.js";

import DatePicker from "../atom/DatePicker.vue";
import DropFile from "../atom/DropFile.vue";
import Header from "../layout/Header.vue";
import TabMenu from "../layout/TabMenu.vue";

const toast = useToast();
const toastNotifications = new toastService(toast);
const router = useRouter();
setupInterceptors(router);

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
    if (weight.value != null) {
      formData.append("record[weight]", weight.value);
    }
    if (fatPercentage.value != null) {
      formData.append("record[fat_percentage]", fatPercentage.value);
    }

    if (isAddAsHidden.value === false) {
      formData.append("record[open_status]", 1);
    }

    for (const file of files.value) {
      if (file != null) {
        formData.append("record[images][]", file);
      }
    }

    const res = await axiosInstance.post("/api/v1/my_records",
      formData,
      {
        headers: {
          'content-type': 'multipart/form-data'
        },
      }
    );
    toastNotifications.displayInfo("登録しました", "");
    setTimeout(async () => {
      showRecordDetail(res.data.record);
    }, 3000);
  } catch (error) {
    let errorMessages = "";
    if (error.response != null && error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      } else {
        errorMessages = error.response.data.errors;
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
    <div class="w-52">
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
      <label for="goal-weight" class="ml-2">kg</label>
    </div>
    <div class="input-group mt-7">
      <FloatLabel>
        <InputText v-model="fatPercentage" class="w-52 h-10 p-2.5" />
        <label>体脂肪率</label>
      </FloatLabel>
      <label for="goal-fat-percentage" class="ml-2">%</label>
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
      <label class="ml-2">非公開記録にする場合にはチェック</label>
    </div>
    <div class="mt-7">
      <p>関連画像(3枚まで登録できます)</p>
      <div v-for="i in 3">
        <DropFile @change="onFileChange" :index="i" class="mt-3" />
      </div>
    </div>
    <div class="pb-5 mt-7 text-center">
      <button class="add-record-button">記録を登録する</button>
    </div>
  </form>
</template>

<style scoped>
.add-record-container {
  width: 600px;
  margin: 0 auto;
  margin-top: 20px;
}
.input-group {
  display: flex;
  align-items: center;
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
  .add-record-container {
    width: auto;
    margin-left: 20px;
    margin-right: 20px;
  }
}
</style>
