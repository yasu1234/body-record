<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router'
import Cookies from 'js-cookie';

import Header from '../layout/Header.vue'

const router = useRouter();
</script>

<template>
  <Header />
  <div class="not-found-container">
    <img src="../../assets/image/not_found.png" alt="ユーザー" class="not-found-image" >
    <p>ページは見つかりません</p>
    <p>お探しのページは一時的にアクセスができない状況にあるか、移動もしくは削除された可能性があります。<br>
        また、URL、ファイル名にタイプミスがないか再度ご確認ください。</p>
    <router-link :to="'/'">ホームに移動</router-link>
  </div>
  
</template>

<style scoped>
.not-found-container {
  width: 100%;
  margin-top: 20px;
  text-align: center;
}
.not-found-image {
    height: 200px;
}
</style>