<script setup>
import { ref, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import axios from "axios";
import Cookies from "js-cookie";
import FloatLabel from "primevue/floatlabel";
import InputText from "primevue/inputtext";
import Textarea from "primevue/textarea";
import Toast from "primevue/toast";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../const/toast.js";

import DropFile from "../atom/DropFile.vue";
import Header from "../layout/Header.vue";
import SettingSideMenu from "../layout/SettingSideMenu.vue";
import TabMenu from "../layout/TabMenu.vue";

const route = useRoute();
const router = useRouter();
const toast = useToast();
const toastNotifications = new toastService(toast);

const goalWeight = ref(null);
const goalFatPercentage = ref(null);
const profile = ref('');
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
    const res = await axios.get(
      import.meta.env.VITE_APP_API_BASE + `/api/v1/profiles/${id}`,
      {
        headers: {
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
      }
    );

    if (res.data.user.goal_weight !== null) {
      goalWeight.value = res.data.user.goal_weight;
    }

    if (res.data.user.goal_fat_percentage !== null) {
      goalFatPercentage.value = res.data.user.goal_fat_percentage;
    }

    if (res.data.user.profile !== null) {
      profile.value = res.data.user.profile;
    }

    if (res.data.user.user.image_url) {
      userThumbnail.value = res.data.user.user.image_url;
    }
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

    const res = await axios.post(
      import.meta.env.VITE_APP_API_BASE + `/api/v1/profiles`,
      formData,
      {
        headers: {
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
      }
    );
    if (file.value !== null) {
      updateProfileImage();
    } else {
      toastNotifications.displayInfo("プロフィールを更新しました", "");
      setTimeout(async () => {
        showProfile(res.data.user.id);
      }, 3000);
    }
  } catch (error) {
    let errorMessages = "";
    if (error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      }
    }
    toastNotifications.displayError("プロフィール変更に失敗しました", errorMessages);
  }
};

const updateProfileImage = async () => {
  try {
    const formData = new FormData();
    if (file.value !== null) {
      formData.append("image", file.value);
    }

    const res = await axios.put(
      import.meta.env.VITE_APP_API_BASE + `/api/v1/auth`,
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
    
    toastNotifications.displayInfo("プロフィールを更新しました", "");
    setTimeout(async () => {
      showProfile(res.data.user.id);
    }, 3000);
  } catch (error) {
    let errorMessages = "";
    if (error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessages += error.response.data.errors.join("\n");
      }
    }
    toastNotifications.displayError("プロフィール画像登録に失敗しました", errorMessages);
  }
};

const showProfile = (id) => {
  router.push({ name: "UserProfile", params: { id: id } });
}
</script>

<template>
  <Header />
  <TabMenu />
  <Toast position="top-center" />
  <div class="setting-container">
    <SettingSideMenu :currentIndex="1" class="setting-side-menu" />
    <main class="setting-main">
      <form @submit.prevent="updateProfile">
        <div class="profile-edit-content">
          <FloatLabel>
            <InputText v-model="goalWeight" />
            <label>目標体重</label>
          </FloatLabel>
          <label for="goal-weight" class="unit-label">kg</label>
        </div>
        <div class="profile-edit-content">
          <FloatLabel>
            <InputText v-model="goalFatPercentage" />
            <label>目標体脂肪率</label>
          </FloatLabel>
          <label for="goal-fat-percentage" class="unit-label">%</label>
        </div>
        <div class="profile-area">
          <FloatLabel>
            <Textarea v-model="profile" rows="10" class="profile-text" />
            <label>紹介文</label>
          </FloatLabel>
        </div>
        <div class="profile-image-change-container">
          <label>プロフィール画像変更</label>
          <div class="current-thumbnail">
            <img
              v-if="userThumbnail !== null"
              :src="userThumbnail.url"
              alt="ユーザーアイコン"
            />
            <img
              v-else
              src="../../assets/image/user-placeholder.png"
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
form {
  margin-left: 15px;
}

.profile-edit-content {
  display: flex;
  align-items: center;
  margin-top: 20px;
}

.unit-label {
  margin-left: 10px;
}

.profile-text {
  height: 100px;
  width: calc(100% - 40px);
}

.profile-area {
  margin-top: 20px;
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
}
.profile-image-change-container {
  margin-top: 20px;
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
  object-fit: cover;
  border-radius: 50%;
}
</style>
