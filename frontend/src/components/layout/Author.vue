<script setup>
import { ref, onMounted, watch } from "vue";
import axios from "axios";
import Cookies from "js-cookie";

const props = defineProps(["author", "userId"]);

const author = ref(null);
const userId = ref(null);
const user = ref(null);

onMounted(() => {
  author.value = props.author;

  getSupport();
});

watch(props, () => {
  author.value = props.author;
});

const getSupport = async () => {
  userId.value = props.userId;
  if (userId === null) {
    return;
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
    user.value = res.data.user;
  } catch (error) {
    if (error.response.status === 404) {
      showNotFound();
    } else {
      errorMessage.value = "";
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
      errorMessage.value = "";
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
      import.meta.env.VITE_APP_API_BASE +
        `/api/v1/supports/${userId.value}`,
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
  <div class="author">
    <div
      class="author-thumbnail-image"
      v-if="
        author !== null &&
        author.image_url !== null &&
        author.image_url.url !== null
      "
    >
      <img
        :src="author.image_url.url"
        alt="ユーザー"
        class="author-thumbnail-image"
      />
    </div>
    <p class="author-name" v-if="author !== null">{{ author.name }}</p>
  </div>
  <div class="support-container">
    <button v-if="author !== null && author.isSupport" class="support-button">
      <img
        src="../../assets/image/support_on.png"
        alt="ユーザー"
        class="support-image"
        @click="supportOff()"
      />
    </button>
    <button v-else class="support-button">
      <img
        src="../../assets/image/support_off.png"
        alt="ユーザー"
        class="support-image"
        @click="supportOn()"
      />
    </button>
    <p class="author-name" v-if="user !== null">{{ user.supportCount }}</p>
  </div>
</template>

<style scoped>
.author {
  display: flex;
  align-items: center;
  margin-top: 10px;
  margin-left: 20px;
}
.author-thumbnail-image {
  width: 40px;
  height: 40px;
  object-fit: cover;
  border-radius: 50%;
}
.author-name {
  margin-left: 10px;
}
.support-container {
  display: flex;
  align-items: center;
  margin-top: 10px;
  margin-left: 20px;
  padding-bottom: 20px;
}
.support-button {
  width: 50px;
  height: 50px;
  background: transparent;
  border: 1px solid #ccc;
  border-radius: 50%;
}
.support-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
</style>
