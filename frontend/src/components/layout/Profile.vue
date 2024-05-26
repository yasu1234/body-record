<script setup>
import { ref, onMounted, watch } from "vue";
import axios from "axios";
import Cookies from "js-cookie";

const props = defineProps(["userId"]);

const profile = ref('');
const userName = ref('');
const userThumbnail = ref(null);
const userId = ref(null);
const user = ref(null);
const goalWeight = ref(null);
const goalFatPercentage = ref(null);
const supportCount = ref(0);
const supporterCount = ref(0);

onMounted(() => {
  getProfile();
  getSupport();
});

watch(props, () => {
  userId.value = props.userId;

  if (user.value === null) {
    getProfile()
    getSupport()
  }
});

const getProfile = async () => {
  if (userId.value === null) {
    user.value = null
    return
  }

  try {
    const res = await axios.get(
      import.meta.env.VITE_APP_API_BASE + `/api/v1/profiles/${userId.value}`,
      {
        headers: {
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
      }
    );

    profile.value = res.data.user.profile;
    userName.value = res.data.user.user.name;
    userThumbnail.value = res.data.user.user.image_url;
    goalFatPercentage.value = res.data.user.goal_fat_percentage;
    goalWeight.value = res.data.user.goal_weight;
  } catch (error) {
    user.value = null
  }
};

const getSupport = async () => {
  if (userId.value === null) {
    user.value = null
    return
  }

  try {
    const res = await axios.get(
      import.meta.env.VITE_APP_API_BASE +
        `/api/v1/supports/user/${userId.value}`,
      {
        headers: {
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
      }
    );
    supportCount.value = res.data.user.supportCount
    supporterCount.value = res.data.user.supporterCount
  } catch (error) {
    if (error.response.status === 404) {
      showNotFound();
    } else {
      let errorMessages = "応援に失敗しました\n";
      if (error.response.status === 422) {
        if (Array.isArray(error.response.data.errors)) {
          errorMessages += error.response.data.errors.join("\n");
        } else {
          errorMessages += error.response.data.errors;
        }
      }
      errorMessage.value = errorMessages;
    }
  }
};

const supportOn = async () => {
  try {
    const formData = new FormData();
    formData.append("id", userId.value);

    const res = await axios.post(
      import.meta.env.VITE_APP_API_BASE + `/api/v1/supports`,
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
    user.value = res.data.user;
  } catch (error) {
    if (error.response.status === 404) {
      showNotFound();
    } else {
      let errorMessages = "応援に失敗しました\n";
      if (error.response.status === 422) {
        if (Array.isArray(error.response.data.errors)) {
          errorMessages += error.response.data.errors.join("\n");
        } else {
          errorMessages += error.response.data.errors;
        }
      }
      errorMessage.value = errorMessages;
    }
  }
};

const supportOff = async () => {
  try {
    const res = await axios.delete(
      import.meta.env.VITE_APP_API_BASE + `/api/v1/supports/${userId.value}`,
      {
        headers: {
          "access-token": Cookies.get("accessToken"),
          client: Cookies.get("client"),
          uid: Cookies.get("uid"),
        },
      }
    );
    user.value = res.data.user;
  } catch (error) {
    if (error.response.status === 404) {
      showNotFound();
    } else {
      errorMessage.value = "";
      let errorMessages = "応援解除に失敗しました\n";
      if (error.response.status === 422) {
        if (Array.isArray(error.response.data.errors)) {
          errorMessages += error.response.data.errors.join("\n");
        } else {
          errorMessages += error.response.data.errors;
        }
      }
      errorMessage.value = errorMessages;
    }
  }
};
</script>

<template>
  <div class="profile-card">
    <div class="profile-card-inner">
      <div class="profile-thumb">
        <img
          v-if="userThumbnail !== null && userThumbnail.url !== null"
          :src="userThumbnail.url"
          alt="ユーザーアイコン"
        />
        <img
          v-else
          src="../../assets/image/user-placeholder.png"
          alt="ユーザーアイコン"
        />
      </div>
      <div class="profile-content">
        <span class="profile-name">{{ userName }}</span>
        <span class="profile-intro">{{ profile }}</span>
        <span class="profile-top-space">目標体重：{{ goalWeight }}</span>
        <span class="profile-top-space">目標体脂肪率：{{ goalFatPercentage }}</span>
      </div>
      <div class="profile-support-container">
        <div class="support-content">{{ supportCount }}<br />サポート</div>
        <div class="support-content">{{ supporterCount }}<br />サポーター</div>
      </div>
      <div class="profile-edit">
        <button class="profile-edit-button" @click="showEditProfile">
          プロフィール編集
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.profile-card {
  width: 100%;
  max-width: 400px;
  position: relative;
  box-shadow: 0px 1px 3px rgba(0, 0, 0, 0.18);
  overflow: hidden;
  margin: 0 auto;
  margin-top: 15px;
}
.profile-card:before {
  width: 120%;
  height: 130px;
  content: "";
  transform: skew(15deg, 10deg);
  background: #9ecaf7;
  position: absolute;
  top: -15%;
  left: -10%;
  z-index: 0;
}
.profile-card-inner {
  position: relative;
  z-index: 1;
}
.profile-thumb {
  overflow: hidden;
  width: 110px;
  height: 110px;
  border: #fff 3px solid;
  border-radius: 55px;
  margin-left: auto;
  margin-right: auto;
  margin-top: 20px;
}
.profile-thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 50%;
}
.profile-content {
  margin: 0 0 20px;
  padding: 15px;
}

.profile-content span {
  display: block;
}
.profile-top-space {
  margin-top: 10px;
}
.profile-name {
  margin-bottom: 3px;
  font-weight: bold;
  text-align: center;
}
.profile-intro {
  font-size: 12px;
}
.profile-support-container {
  align-items: center;
  border-top: 1px solid #ffa500;
  display: flex;
  margin-top: 8px;
  padding-top: 8px;
  width: 100%;
}
.support-content {
  line-height: 1.5;
  text-align: center;
  width: calc(49%);
}
.profile-edit {
  padding-top: 5px;
  padding-bottom: 10px;
  text-align: center;
}

.profile-edit-button {
  font-size: 16px;
  font-weight: bold;
  margin: 0 auto;
}
</style>
