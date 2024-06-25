<template>
  <div class="support-container" v-if="user != null">
    <div
      class="user-thumbnail-image"
      v-if="user.image_url !== null && user.image_url.url !== null"
    >
      <img
        :src="user.image_url.url"
        alt="ユーザー"
        class="user-thumbnail-image"
      />
    </div>
    <div>
      <Button
        class="user-name-link ml-2"
        :label="user.name"
        @click.stop="showUser"
        link
      />
    </div>
  </div>
  <p class="text-left mt-2.5 ml-5">
    {{ profile }}
  </p>
  <div class="text-right mt-2.5 mr-2.5 pb-5">
    <button
      v-if="isSupport"
      class="support-delete-button support-button"
      @click="supportOff"
    >
      サポート解除
    </button>
    <button v-else class="support-button" @click="supportOn">
      サポートする
    </button>
  </div>
</template>

<script setup>
import { useRouter } from "vue-router";
import { ref, onMounted, watch } from "vue";
import Button from "primevue/button";

const router = useRouter();

const props = defineProps(["user", "isSupport"]);
const emit = defineEmits(["support-off", "support-on"]);

const user = ref(null);
const latestRecordDate = ref(null);
const profile = ref("");
const isSupport = ref(false);

onMounted(() => {
  setProps(props);
});

watch(props, () => {
  setProps(props);
});

const setProps = (props) => {
  user.value = props.user;
  isSupport.value = props.isSupport;
  if (props.user.latest_record != null) {
    latestRecordDate.value = props.user.latest_record.formatted_date;
  } else {
    latestRecordDate.value = null;
  }

  if (props.user.profile != null && props.user.profile.profile != null) {
    profile.value = props.user.profile.profile;
  } else {
    profile.value = "";
  }
};

const showUser = () => {
  router.push({ name: "UserProfile", params: { id: user.value.id } });
};

const supportOn = () => {
  emit("support-on", user.value.id);
};

const supportOff = () => {
  emit("support-off", user.value.id);
};
</script>

<style scoped>
.support-container {
  display: flex;
  align-items: center;
  margin-top: 10px;
  margin-left: 20px;
}
.user-thumbnail-image {
  width: 40px;
  height: 40px;
  border-radius: 50%;
}
.user-name-link {
  background-color: transparent;
  color: #ffa500;
  font-weight: bold;
}
.latest-record-date {
  font-size: 14px;
}
.support-button {
  padding: 5px 10px;
}
.support-delete-button {
  background: #d50c05;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
}
</style>
