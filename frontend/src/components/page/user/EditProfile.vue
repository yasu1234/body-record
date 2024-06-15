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
setupInterceptors(router)

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
  const id = route.params.id;

  try {
    const res = await axiosInstance.get(`/api/v1/profiles/${id}`);

    goalWeight.value = res.data.user.profile.goal_weight;
    goalFatPercentage.value = res.data.user.profile.goal_fat_percentage;

    if (res.data.user.profile.profile !== null) {
      profile.value = res.data.user.profile.profile;
    }

    userThumbnail.value = res.data.user.user.image_url;
  } catch (error) {
    console.log({ error });
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
            <Textarea v-model="profile" rows="10" class="profile-text p-2.5" />
            <label>紹介文</label>
          </FloatLabel>
        </div>
        <div class="mt-5">
          <label>プロフィール画像変更</label>
          <div class="current-thumbnail">
            <img
              v-if="userThumbnail !== null"
              :src="userThumbnail.url"
              alt="ユーザーアイコン"
            />
            <img
              v-else
              src="../../../assets/image/user-placeholder.png"
              alt="ユーザーアイコン"
            />
          </div>
          <DropFile @change="onFileChange" />
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
.profile-text {
  height: 100px;
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
.current-thumbnail img {
  width: 100%;
  height: 100%;
  border-radius: 50%;
}
</style>
