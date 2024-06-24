<template>
  <div class="user-container" v-if="user != null">
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
        class="user-name-link"
        :label="user.name"
        @click.stop="showUser"
        link
      />
    </div>
  </div>
  <p class="latest-record-date mt-2.5 ml-5">
    最新の記録： {{ latestRecordDate != null ? latestRecordDate : "記録なし" }}
  </p>
  <div class="support-container mt-2.5 ml-5 pb-5">
    <div v-if="isMySupport" class="support-button">
      <img
        src="../../assets/image/support_on.png"
        alt="サポート中"
        class="support-image"
      />
    </div>
    <div v-else class="support-button">
      <img
        src="../../assets/image/support_off.png"
        alt="未サポート"
        class="support-image"
      />
    </div>
    <p class="ml-2.5">{{ supporterCount }}</p>
  </div>
</template>

<script setup>
import { useRouter } from "vue-router";
import { ref, onMounted, watch } from "vue";
import Button from "primevue/button";

const router = useRouter();

const props = defineProps(["user"]);

const user = ref(null);
const latestRecordDate = ref(null);
const supporterCount = ref(0);
const isMySupport = ref(false);

onMounted(() => {
  setProps(props);
});

watch(props, () => {
  setProps(props);
});

const setProps = (props) => {
  user.value = props.user;
  if (props.user.latest_record != null) {
    latestRecordDate.value = props.user.latest_record.formatted_date;
  }
  if (props.user != null && props.user.is_support != null) {
    isMySupport.value = props.user.is_support;
  } else {
    isMySupport.value = false;
  }
  if (props.user != null) {
    supporterCount.value = props.user.supporter_count;
  } else {
    supporterCount.value = 0;
  }
}

const showUser = () => {
  router.push({ name: "UserProfile", params: { id: user.value.id } });
};
</script>

<style scoped>
.user-container {
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
.support-container {
  display: flex;
  align-items: center;
}
.support-button {
  width: 50px;
  height: 50px;
  background: transparent;
  border: 1px solid #ccc;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
}
.support-image {
  width: 100%;
  height: auto;
}
</style>
