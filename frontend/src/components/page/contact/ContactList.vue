<template>
  <Header />
  <TabMenu />
  <Toast position="top-center" />
  <p class="title_line mt-5">お問合せ一覧</p>
  <p class="mt-5 mx-5 text-lg">
    対応済みのお問い合わせは次の日には表示されなくなるのでご注意ください
  </p>
  <div class="pb-8">
    <div
      class="contact-card"
      v-for="item of searchResult"
      :key="item.id"
      @click="clickContact(item)"
    >
      <div class="complete-image" v-if="item.status === 1">
        <p class="contact-complete">対応済</p>
      </div>
      <div class="pb-2.5">
        <p class="mx-2.5 mt-2.5">
          {{ item.content != null ? item.content : "" }}
        </p>
      </div>
      <div>
        <p class="contact-create-date mt-2.5">
          {{ item.contact_date_format != null ? item.contact_date_format : "" }}
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { axiosInstance } from "../../../js/axios.js";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../../js/toast.js";
import Toast from "primevue/toast";

import Header from "../../layout/Header.vue";
import TabMenu from "../../layout/TabMenu.vue";

const router = useRouter();
const toast = useToast();
const toastNotifications = new toastService(toast);

const searchResult = ref([]);

onMounted(() => {
  getContactList();
});

const getContactList = async () => {
  try {
    const res = await axiosInstance.get("/api/v1/contacts");

    for (let item of res.data.contacts) {
      searchResult.value.push(item);
    }
  } catch (error) {
    searchResult.value = [];
    toastNotifications.displayError("お問合せ送信に失敗しました", "");
  }
};

const clickContact = (item) => {
  router.push({ name: "ContactDetail", params: { id: item.id } });
};
</script>

<style scoped>
.contact-card {
  border: 1px solid #ccc;
  border-radius: 5px;
  cursor: pointer;
  width: 700px;
  margin: 0 auto;
  padding: 15px;
  background-color: #ffffff;
  border-radius: 5px;
  margin-top: 20px;
}
.complete-image {
  border-radius: 20px;
  background: #ffa500;
  margin-top: 10px;
  padding: 0px 16px;
  width: 100px;
  margin-left: 10px;
  font-weight: bold;
}
.contact-complete {
  font-size: 15px;
  text-align: center;
}
.contact-create-date {
  color: #928484;
  font-size: 12px;
  text-align: right;
}

@media screen and (max-width: 768px) {
  .contact-card {
    width: auto;
    margin-left: 20px;
    margin-right: 20px;
  }
}
</style>
