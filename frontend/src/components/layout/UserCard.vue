<script setup>
import { useRouter } from "vue-router";
import { ref, onMounted, watch } from "vue";
import Button from "primevue/button";

const router = useRouter();
const user = ref(null);

const props = defineProps(["user"]);

onMounted(() => {
  user.value = props.user;
});

watch(
  () => props.user,
  (newUser) => {
    user.value = newUser;
  }
);

const showUser = (item) => {
  router.push({ name: "UserProfile", params: { id: item.id } });
};
</script>

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
        @click.stop="showUser(user)"
        link
      />
    </div>
  </div>
</template>

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
  object-fit: cover;
  border-radius: 50%;
}
.user-name-link {
  background-color: transparent;
  color: #ffa500;
  font-weight: bold;
}
</style>
