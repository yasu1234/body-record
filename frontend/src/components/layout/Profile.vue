<template>
  <div class="profile-card">
    <div class="profile-card-inner">
      <div class="profile-thumb">
        <img
          v-if="userThumbnail !== null && userThumbnail.url !== null"
          :src="userThumbnail.url"
          alt="ユーザーアイコン"
        />
        <div v-else class="profile-thumb-image">
          <i class="pi pi-user" style="font-size: 60px; color: white" ></i>
        </div>
      </div>
      <div class="profile-content">
        <p class="profile-name">{{ userName != null ? userName : "" }}</p>
        <p class="profile-intro break-words">
          {{ profileMessage != null ? profileMessage : "" }}
        </p>
        <p class="mt-2.5">目標体重：{{ goalWeight }}kg</p>
        <p class="mt-2.5">目標体脂肪率：{{ goalFatPercentage }}%</p>
      </div>
      <div class="profile-support-container">
        <button
          class="support-content hover:underline"
          @click="showSupportList"
        >
          {{ supportCount }}<br />サポート
        </button>
        <button class="support-content hover:underline" @click="showSupporter">
          {{ supporterCount }}<br />サポーター
        </button>
      </div>
      <div class="profile-edit">
        <div v-if="isMyProfile">
          <button class="profile-edit-button" @click="showEditProfile">
            プロフィール編集
          </button>
        </div>
        <div v-else>
          <button
            v-if="isSupport"
            class="profile-edit-button"
            @click="editSupport"
          >
            サポーター解除
          </button>
          <button v-else class="profile-edit-button" @click="editSupport">
            サポートする
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from "vue";
import { useRouter } from "vue-router";
import Button from "primevue/button";

const props = defineProps(["user", "support"]);
const emit = defineEmits(["edit-support"]);

const router = useRouter();

const profileMessage = ref("");
const userName = ref("");
const userThumbnail = ref(null);
const userId = ref(null);
const goalWeight = ref(null);
const goalFatPercentage = ref(null);
const supportCount = ref(0);
const supporterCount = ref(0);
const isMyProfile = ref(false);
const isSupport = ref(false);

onMounted(() => {
  setProfile(props.user);
  setSupport(props.support);
});

watch(props, () => {
  setProfile(props.user);
  setSupport(props.support);
});

const setProfile = (user) => {
  if (user == null) {
    profileMessage.value = "";
    userName.value = "";
    userThumbnail.value = null;
    goalFatPercentage.value = null;
    goalWeight.value = null;
    isMyProfile.value = false;
    return;
  }

  userName.value = user.name;
  userThumbnail.value = user.image_url;
  userId.value = user.id;

  if (user.profile != null) {
    profileMessage.value = user.profile.profile;
    goalFatPercentage.value = user.profile.goal_fat_percentage;
    goalWeight.value = user.profile.goal_weight;
  }

  if (user.is_my_profile != null && user.is_my_profile === true) {
    isMyProfile.value = true;
  } else {
    isMyProfile.value = false;
  }
};

const setSupport = (support) => {
  if (support == null) {
    supportCount.value = 0;
    supporterCount.value = 0;
    isSupport.value = false;
    return;
  }

  if (support.support_count != null) {
    supportCount.value = support.support_count;
  } else {
    supportCount.value = 0;
  }

  if (support.supporter_count != null) {
    supporterCount.value = support.supporter_count;
  } else {
    supporterCount.value = 0;
  }

  if (support.is_support != null) {
    isSupport.value = support.is_support;
  } else {
    isSupport.value = false;
  }
};

const editSupport = () => {
  emit("edit-support", isSupport.value);
};

const showEditProfile = () => {
  router.push({ name: "EditProfile", params: { id: userId.value } });
};

const showSupporter = () => {
  router.push({ name: "SupporterList", params: { id: userId.value } });
};

const showSupportList = () => {
  router.push({ name: "SupportList", params: { id: userId.value } });
};
</script>

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
.profile-thumb-image {
  width: 100%;
  height: 100%;
  border-radius: 50%;
  background: #4264ec;
  display: flex;
  align-items: center;
  justify-content: center;
}
.profile-content {
  margin: 0 0 20px;
  padding: 15px;
}
.profile-content span {
  display: block;
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
  background: #f5f6f6;
  color: #000;
}
.profile-edit {
  padding: 10px 0px;
  text-align: center;
}

.profile-edit-button {
  font-size: 16px;
  font-weight: bold;
  margin: 0 auto;
  padding: 5px 20px;
}

@media screen and (max-width: 768px) {
  .profile-card {
    width: auto;
    margin-left: 20px;
    margin-right: 20px;
  }
}
</style>
