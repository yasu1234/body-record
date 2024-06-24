<script setup>
import { ref, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import FloatLabel from "primevue/floatlabel";
import InputText from "primevue/inputtext";
import Textarea from "primevue/textarea";
import Toast from "primevue/toast";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../../js/toast.js";
import { axiosInstance, setupInterceptors } from "../../../js/axios.js";

import DropFile from "../../atom/DropFile.vue";
import Header from "../../layout/Header.vue";
import SettingSideMenu from "../../layout/SettingSideMenu.vue";
import TabMenu from "../../layout/TabMenu.vue";

const route = useRoute();
const router = useRouter();
const toast = useToast();
const toastNotifications = new toastService(toast);
setupInterceptors(router);

const goalWeight = ref(null);
const goalFatPercentage = ref(null);
const profile = ref("");
const file = ref(null);
const userThumbnail = ref(null);
const userId = ref(0);

function onFileChange(event) {
  file.value = event[0];
}

onMounted(() => {
  getProfile();
});

const getProfile = async () => {
  userId.value = route.params.id;

  try {
    const res = await axiosInstance.get(`/api/v1/profiles/${userId.value}`);

    userThumbnail.value = res.data.user.image_url;

    if (res.data.user.profile == null) {
      goalWeight.value = null;
      goalFatPercentage.value = null;
      profile.value = "";
      return;
    }  

    goalWeight.value = res.data.user.profile.goal_weight;
    goalFatPercentage.value = res.data.user.profile.goal_fat_percentage;
    if (res.data.user.profile.profile !== null) {
      profile.value = res.data.user.profile.profile;
    } else {
      profile.value = ""
    }
  } catch (error) {
    let errorMessage = "";
    if (error.response != null && error.response.status === 401) {
      errorMessage = "ログインしてください";
    }
    toastNotifications.displayError("プロフィール情報取得に失敗しました", errorMessage);
  }
};

const updateProfile = async () => {
  try {
    const formData = new FormData();
    formData.append("profile", profile.value);
    formData.append("goal_weight", goalWeight.value);
    formData.append("goal_fat_percentage", goalFatPercentage.value);

    const res = await axiosInstance.post(`/api/v1/profiles`, formData);
    if (file.value !== null) {
      updateProfileImage();
    } else {
      toastNotifications.displayInfo("プロフィールを更新しました", "");
      setTimeout(async () => {
        showMyPage();
      }, 3000);
    }
  } catch (error) {
    let errorMessages = "";
    if (error.response != null && error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      } else {
        errorMessages = error.response.data.errors;
      }
    } else if (error.response.status === 401) {
      errorMessages = "ログインしてください";
    }

    toastNotifications.displayError(
      "プロフィール変更に失敗しました",
      errorMessages
    );
  }
};

const updateProfileImage = async () => {
  try {
    const formData = new FormData();
    if (file.value !== null) {
      formData.append("image", file.value);
    }

    const res = await axiosInstance.put(`/api/v1/auth`, formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });

    toastNotifications.displayInfo("プロフィールを更新しました", "");
    setTimeout(async () => {
      showMyPage();
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
    toastNotifications.displayError(
      "プロフィール画像登録に失敗しました",
      errorMessages
    );
  }
};

const showMyPage = () => {
  router.push({ name: "MyPage" });
};
</script>

<template>
  <Header />
  <TabMenu />
  <Toast position="top-center" />
  <div class="setting-container">
    <SettingSideMenu :currentIndex="1" class="setting-side-menu" />
    <main class="setting-main">
      <form @submit.prevent="updateProfile" class="ml-3.5 pb-5">
        <div class="profile-edit-content">
          <FloatLabel>
            <InputText v-model="goalWeight" class="p-2.5" />
            <label>目標体重</label>
          </FloatLabel>
          <label for="goal-weight" class="ml-2.5">kg</label>
        </div>
        <div class="profile-edit-content">
          <FloatLabel>
            <InputText v-model="goalFatPercentage" class="p-2.5" />
            <label>目標体脂肪率</label>
          </FloatLabel>
          <label for="goal-fat-percentage" class="ml-2.5">%</label>
        </div>
        <div class="mt-5">
          <FloatLabel>
            <Textarea
              v-model="profile"
              rows="10"
              class="profile-input-width h-full p-2.5"
            />
            <label>紹介文</label>
          </FloatLabel>
          <div class="mt-2 text-right profile-input-width">
            <p v-if="profile.length > 200" class="text-red-500">
              200文字以上入力しています
            </p>
            <p v-else>残り{{ 200 - profile.length }}文字入力できます</p>
          </div>
        </div>
        <div class="mt-5">
          <label>プロフィール画像変更</label>
          <div v-if="userThumbnail !== null" class="current-thumbnail">
            <img
              :src="userThumbnail.url"
              alt="ユーザーアイコン"
            />
          </div>
          <div v-else class="edit-profile-thumb-image">
            <i class="pi pi-user" style="font-size: 40px; color: white" />
          </div>
          <DropFile @change="onFileChange" class="mt-5" />
        </div>
        <button class="edit-profile-button">更新する</button>
      </form>
    </main>
  </div>
</template>

<style scoped>
.profile-edit-content {
  display: flex;
  align-items: center;
  margin-top: 20px;
}
.profile-input-width {
  width: calc(100% - 40px);
}
.setting-side-menu {
  z-index: 30;
  flex: 1;
}
.setting-main {
  width: 100%;
}
.edit-profile-button {
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  display: block;
  width: 180px;
  margin: 0 auto;
  margin-top: 30px;
  padding: 10px 30px;
}
.current-thumbnail {
  width: 80px;
  height: 80px;
  border: #ccc 1px solid;
  border-radius: 50%;
  margin-top: 20px;
  margin-bottom: 20px;
}
.edit-profile-thumb-image {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background: #4264ec;
  display: flex;
  align-items: center;
  justify-content: center;
}
.current-thumbnail img {
  width: 100%;
  height: 100%;
  border-radius: 50%;
}
</style>
