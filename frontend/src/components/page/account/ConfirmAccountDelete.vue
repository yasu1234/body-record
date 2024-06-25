<template>
  <Header />
  <TabMenu />
  <Toast position="top-center" />
  <div class="setting-container">
    <SettingSideMenu :currentIndex="4" class="setting-side-menu" />
    <main class="setting- px-2.5">
      <p class="confirm-account-delete-title mt-5">
        退会前に必ずチェックしてください
      </p>
      <p class="mt-5">
        ・退会すると今までログインしていたアドレスやパスワードではログインできません
      </p>
      <p class="mt-5">・退会すると今まで登録した記録や記事が削除されます</p>
      <p class="mt-5">・退会するとコメントやブックマークの記録も削除されます</p>
      <p class="mt-5">
        ・再度サービスを使用する際には会員登録から再度行い必要があります
      </p>
      <div class="mt-8">
        <input
          type="checkbox"
          id="statusSelect"
          v-model="isChecked"
          class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500"
        />
        <label class="ml-2">注意事項を確認して、了承しました</label>
      </div>
      <button class="delete-account-button mt-8 py-2.5 px-12" @click="confirm">
        退会する
      </button>
      <div v-if="isShowConfirmDialog" class="modal-overlay">
        <ConfirmDialog
          :title="'アカウントを削除します'"
          :message="'削除すると今までの記録は消去されます よろしいですか'"
          :positiveButtonTitle="'退会する'"
          @handle-positive="accountDelete"
          @cancel="cancel"
        />
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import Toast from "primevue/toast";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../../js/toast.js";
import { axiosInstance, setupInterceptors } from "../../../js/axios.js";

import Header from "../../layout/Header.vue";
import SettingSideMenu from "../../layout/SettingSideMenu.vue";
import TabMenu from "../../layout/TabMenu.vue";
import ConfirmDialog from "../../layout/ConfirmDialog.vue";

const router = useRouter();
const toast = useToast();
const toastNotifications = new toastService(toast);
setupInterceptors(router);

const isChecked = ref(false);
const isShowConfirmDialog = ref(false);

const deleteAccount = async () => {
  try {
    const res = await axiosInstance.delete("/api/v1/auth");

    Cookies.remove("accessToken");
    Cookies.remove("client");
    Cookies.remove("uid");

    router.push({ name: "Home" });
  } catch (error) {
    let errorMessage = "";
    if (error.response.status === 422) {
      if (Array.isArray(error.response.data.errors)) {
        errorMessage += error.response.data.errors.join("\n");
      } else {
        errorMessage = error.response.data.errors;
      }
    }

    toastNotifications.displayError("退会に失敗しました", errorMessage);
  }
};

const confirm = () => {
  if (isChecked.value) {
    isShowConfirmDialog.value = true;
  } else {
    isShowConfirmDialog.value = false;
    toastNotifications.displayError(
      "退会する場合にはチェックボックスにチェックを入れてください",
      ""
    );
  }
};

const accountDelete = () => {
  isShowConfirmDialog.value = false;
  deleteAccount();
};

const cancel = () => {
  isShowConfirmDialog.value = false;
};
</script>

<style scoped>
.confirm-account-delete-title {
  font-weight: 800;
  font-size: 18px;
}
.setting-side-menu {
  z-index: 30;
  flex: 1;
}
.setting-main {
  width: 100%;
}
.delete-account-button {
  background: #d50c05;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
}
.delete-account-cancel-button {
  background: #fff;
  color: #000000;
  border: 1px solid #ccc;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
}
</style>
