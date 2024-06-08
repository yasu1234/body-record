<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { axiosInstance } from "../../const/axios.js";

import Header from "../layout/Header.vue";

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
    console.log({ error });
  }
};

function clickContact(item) {
  router.push({ name: "ContactDetail", params: { id: item.id } });
}
</script>

<template>
  <Header />
  <div
    class="contact-card"
    v-for="item of searchResult"
    :key="item.id"
    @click="clickContact(item)"
  >
    <div class="complete-image" v-if="item.status === 1">
      <p class="contact-complete">対応済</p>
    </div>
    <div>
      <p class="idea-content">{{ item.content }}</p>
    </div>
  </div>
</template>

<style scoped>
.search-button-area {
  text-align: center;
}
.search-button {
  background: #ffa500;
  color: white;
  font-size: 16px;
  font-weight: bold;
}

.contact-card {
  margin: 10px 12px 12px 12px;
  border: 1px solid #ccc;
  border-radius: 5px;
}
.idea-content {
  margin: 10px 0px 10px 10px;
}
.add-button-area {
  text-align: right;
  margin-top: 20px;
  padding-right: 40px;
}
.add-button {
  background: #ffa500;
  color: white;
  font-size: 16px;
  font-weight: bold;
}
.complete-image {
  border-radius: 20px;
  background: #ffa500;
  margin-top: 10px;
  padding-right: 16px;
  padding-left: 16px;
  width: 50px;
  margin-left: 10px;
  font-weight: bold;
}
.contact-complete {
  font-size: 15px;
}
</style>
