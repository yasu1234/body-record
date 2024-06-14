<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { axiosInstance } from "../../../const/axios.js";

import Header from "../../layout/Header.vue";
import TabMenu from "../../layout/TabMenu.vue";

const router = useRouter();

const isLogin = ref(false);
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
  }
};

function clickContact(item) {
  router.push({ name: "ContactDetail", params: { id: item.id } });
}
</script>

<template>
  <Header />
  <TabMenu />
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
      <p class="mx-2.5 mt-2.5">{{ item.content }}</p>
    </div>
  </div>
</template>

<style scoped>
.contact-card {
  margin: 10px 12px 12px 12px;
  border: 1px solid #ccc;
  border-radius: 5px;
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
</style>
