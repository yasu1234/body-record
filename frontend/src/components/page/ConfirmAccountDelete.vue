<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import Toast from "primevue/toast";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../const/toast.js";
import { axiosInstance, setupInterceptors } from "../../const/axios.js";

import Header from "../layout/Header.vue";
import SettingSideMenu from "../layout/SettingSideMenu.vue";
import TabMenu from "../layout/TabMenu.vue";

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
        <div class="modal-container">
          <div class="modal-header">
            <slot name="header">アカウントを削除します</slot>
          </div>
          <div class="modal-body">
            <slot name="body"
              ><p>
                削除すると今までの記録は消去されます<br />よろしいですか？
              </p></slot
            >
          </div>
          <div class="text-right">
            <slot name="footer">
              <button
                class="delete-account-button mr-2.5 py-2.5 px-5"
                @click="accountDelete"
              >
                退会する
              </button>
              <button
                class="delete-account-cancel-button py-2.5 px-5"
                @click="cancel"
              >
                キャンセル
              </button>
            </slot>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

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
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;
}
.modal-container {
  background-color: #fff;
  border-radius: 5px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.33);
  padding: 20px;
  width: 500px;
}
.modal-header {
  margin-top: 0;
  font-size: 20px;
}
.modal-body {
  margin: 20px 0;
  line-height: 1.6;
}

@media (max-width: 768px) {
  .modal-container {
    margin-left: 10px;
    margin-right: 10px;
    width: auto;
  }
}
</style>
