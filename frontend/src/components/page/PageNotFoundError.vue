<script setup>
import Header from "../layout/Header.vue";
</script>

<template>
  <Header />
  <div class="not-found-container mt-5 px-2.5">
    <img
      src="../../assets/image/not_found.png"
      alt="ユーザー"
      class="not-found-image"
    />
    <p class="mt-2.5 font-bold">ページは見つかりません</p>
    <p class="mt-5">
      お探しのページは一時的にアクセスができない状況にあるか、移動もしくは削除された可能性があります。<br />
      また、URL、ファイル名にタイプミスがないか再度ご確認ください。
    </p>
    <div class="mt-5">
      <router-link :to="'/'">ホームに移動</router-link>
    </div>
  </div>
</template>

<style scoped>
.not-found-container {
  width: 100%;
  text-align: center;
}
.not-found-image {
  height: 200px;
  margin: 0px auto;
}
.not-found-container a {
  text-decoration: underline;
  font-size: 20px;
  color: #f58505
}
</style>
