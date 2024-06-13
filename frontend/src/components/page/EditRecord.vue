<script setup>
import { ref, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import Toast from "primevue/toast";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../const/toast.js";
import Textarea from "primevue/textarea";
import FloatLabel from "primevue/floatlabel";
import InputText from "primevue/inputtext";
import Button from "primevue/button";
import { axiosInstance, setupInterceptors } from "../../const/axios.js";

import DropFile from "../atom/DropFile.vue";
import DatePicker from "../atom/DatePicker.vue";
import Header from "../layout/Header.vue";
import TabMenu from "../layout/TabMenu.vue";

const route = useRoute();
const router = useRouter();
const toast = useToast();
const toastNotifications = new toastService(toast);
setupInterceptors(router)

const recordDate = ref("");
const memo = ref("");
const weight = ref(null);
const fatPercentage = ref(null);
const files = ref([...Array(3)]);
const imageUrls = ref([]);
const recordId = ref(null);
const isHidden = ref(false);

onMounted(() => {
  getDetail();
});

function dateChange(event) {
  recordDate.value = event;
}

const onFileChange = (event, index) => {
  files.value[index - 1] = event;
}

const deleteImage = async (item) => {
  try {
    const res = await axiosInstance.delete("/api/v1/record/image", {
      params: {
        id: recordId.value,
        image_id: item.id,
      },
    });
    imageUrls.value = res.data.imageUrls;
  } catch (error) {
    toastNotifications.displayError("画像の削除に失敗しました", "");
  }
};

const getDetail = async () => {
  const id = route.params.id;
  try {
    const res = await axiosInstance.get(`/api/v1/records/${id}`);
    recordId.value = res.data.record.id;
    recordDate.value = res.data.record.calendar_date;
    weight.value = res.data.record.weight;
    fatPercentage.value = res.data.record.fat_percentage;
    memo.value = res.data.record.memo;
    imageUrls.value = res.data.record.image_urls;
    isHidden.value = !res.data.record.is_open;
  } catch (error) {
    toastNotifications.displayError("記録の取得に失敗しました", errorMessages);
  }
};

const edit = async () => {
  try {
    const formData = new FormData();
    formData.append("record[memo]", memo.value);
    formData.append("record[date]", recordDate.value);
    if (weight.value !== null) {
      formData.append("record[weight]", weight.value);
    }
    if (fatPercentage.value !== null) {
      formData.append("record[fat_percentage]", fatPercentage.value);
    }

    if (isHidden.value === false) {
      formData.append("record[open_status]", 1);
    }

    for (const file of files.value) {
      formData.append("record[images][]", file);
    }

    const res = await axiosInstance.patch(
      `/api/v1/my_records/${recordId.value}`,
      formData,
      {
        headers: {
          "Content-Type": "multipart/form-data",
        },
      }
    );
    recordId.value = res.data.record.id;

    toastNotifications.displayInfo("編集しました", "");
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
    toastNotifications.displayError("記録の更新に失敗しました", errorMessages);
  }
};

const showRecordDetail = () => {
  router.push({ name: "RecordDetail", params: { id: recordId.value } });
};
</script>

<template>
  <Header />
  <TabMenu />
  <Toast position="top-center" />
  <form class="edit-container" @submit.prevent="edit">
    <div class="w-52">
      <p class="inputTitle">記録日</p>
      <DatePicker isStart="true" :date="recordDate" @update:date="dateChange" />
    </div>
    <div class="weight-group mt-7">
      <FloatLabel>
        <InputText v-model="weight" class="w-52 h-10 p-2.5" />
        <label>体重</label>
      </FloatLabel>
      <p class="ml-2">kg</p>
    </div>
    <div class="weight-group mt-7">
      <FloatLabel>
        <InputText v-model="fatPercentage" class="w-52 h-10 p-2.5" />
        <label>体脂肪率</label>
      </FloatLabel>
      <p class="ml-2">%</p>
    </div>
    <div class="mt-5">
      <FloatLabel>
        <Textarea v-model="memo" rows="10" class="record-memo p-2.5" />
        <label>メモ</label>
      </FloatLabel>
    </div>
    <div class="mt-7">
      <input
        type="checkbox"
        id="statusSelect"
        v-model="isHidden"
        class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500"
      />
      <label class="ml-2">非公開記録にする場合にはチェック</label>
    </div>
    <div v-if="imageUrls !== null && imageUrls.length !== 0">
      <p class="mt-5">登録済みの画像</p>
      <div class="thumbnail-container">
        <div class="thumbnail" v-for="item in imageUrls">
          <div class="thumbnail-image">
            <img :src="item.url" alt="" />
          </div>
          <div class="thumbnail-actions">
            <Button
              label=""
              icon="pi pi-trash"
              class="delete-button"
              @click="deleteImage(item)"
            />
          </div>
        </div>
      </div>
    </div>
    <div class="mt-5">
      <p>関連画像(登録済みの画像と合わせて3枚まで登録できます)</p>
      <div v-for="i in 3">
        <DropFile @change="onFileChange" :index="i" class="mt-3" />
      </div>
    </div>
    <div class="p-5 text-center">
      <button class="record-edit-button">編集する</button>
    </div>
  </form>
</template>

<style scoped>
.edit-container {
  width: 600px;
  margin: 0 auto;
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
.weight-group {
  display: flex;
  align-items: center;
}
.record-edit-button {
  font-size: 16px;
  font-weight: bold;
  padding: 10px 50px;
  cursor: pointer;
}
.thumbnail-container {
  display: flex;
  flex-wrap: wrap;
  justify-content: flex-start;
  padding: 20px;
}
.thumbnail {
  position: relative;
  display: inline-block;
  height: 200px;
  margin-right: 15px;
  margin-bottom: 15px;
  padding-left: 20px;
}
.thumbnail img {
  height: 100%;
}
.thumbnail-image {
  height: 100%;
}
.thumbnail-image img {
  height: 100%;
}
.thumbnail-actions {
  position: absolute;
  top: 5px;
  right: 5px;
}
.delete-button {
  background-color: rgba(255, 255, 255, 0.7);
  border: none;
  color: #000;
  text-align: center;
  border-radius: 4px;
  cursor: pointer;
  border-radius: 50%;
  width: 30px;
  height: 30px;
  cursor: pointer;
}
.record-memo {
  width: 500px;
}
@media (max-width: 768px) {
  .record-memo {
    width: calc(100% - 20px);
  }
  .edit-container {
    width: auto;
    margin-left: 20px;
    margin-right: 20px;
  }
}
</style>
