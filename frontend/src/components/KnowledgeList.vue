<script setup>
import { ref, onMounted } from 'vue';
import { useRouter, onBeforeRouteUpdate } from 'vue-router'
import axios from 'axios';
import Cookies from 'js-cookie';

import TabMenu from './TabMenu.vue'

const router = useRouter();

const keyword = ref("");
const isBookmark = ref(false);
const isLogin = ref(false);
const searchResult = ref([]);

const currentId = ref(3);

onMounted(() => {
  search();
});

onBeforeRouteUpdate(async (to, from) => {
  keyword.value = to.query.keyword;
  search();
});

const targetSearch = ()=> {
}

const search = async () => {
  try {
    const res = await axios.get(import.meta.env.VITE_APP_API_BASE + '/api/v1/knowledges', {
      headers: {
        'access-token' : Cookies.get('accessToken'),
        'client':Cookies.get('client'),
        'uid': Cookies.get('uid'),
      },

      params: {
        keyword: keyword.value
      }
    })
    
    for(let item of res.data.knowledges){
      searchResult.value.push(item);
    }
  } catch (error) {
    console.log({ error })
  }
}

function clickKnowledge(item) {
  router.push({ name: 'EditKnowledge', params: { id: item.id }})
}

function addKnowledge() {
  router.push("/addKnowledge")
}
</script>

<template>
    <TabMenu :currentId="currentId"/>
    <div class="keyword-search">
        <input type="text" id="keyword" name="keywordName" placeholder="キーワードで絞り込む" v-model="keyword">
    </div>
    <div class="search-check">
      <input type="checkbox" id="statusSelect" v-model="isBookmark">
      <label for="statusSelectName">ブックマークのみ絞り込む</label>
    </div>
    <div class="search-button-area">
        <button class="search-button" @click="targetSearch">検索</button>
    </div>
    <div class="add-button-area">
        <button class="add-button" @click="addKnowledge">ノウハウを追加する</button>
    </div>
    <div class="knowledge-card" v-for="item of searchResult" :key="item.id" @click="clickKnowledge(item)">
      <h4 class="knowledge-title"><b>{{ item.title }}</b></h4>
      <div>
        <p class="idea-content">{{ item.content }}</p>
      </div>
    </div>
</template>

<style>
.keyword-search {
   padding: 30px;
 }

 input[type=text] {
  width: 100%;
  padding: 12px 12px;
  margin: 8px 0;
  box-sizing: border-box;
  border: 1px solid #ccc;
  border-radius: 4px;
}
input[type="checkbox"] {
  border-radius: 0;
  -webkit-appearance: none;
     -moz-appearance: none;
          appearance: none;
}
input[type="checkbox"] {
  position: relative;
  width: 16px;
  height: 16px;
  border: 1px solid #000;
  vertical-align: -5px;
}

input[type="checkbox"]:checked:before {
  position: absolute;
  top: 1px;
  left: 4px;
  transform: rotate(50deg);
  width: 4px;
  height: 8px;
  border-right: 2px solid #000;
  border-bottom: 2px solid #000;
  content: '';
}
.search-check {
  margin-top: 20px;
  padding-left: 20px;
  padding-right: 20px;
}
.search-button-area {
  text-align: center;
}
.search-button {
  background: #ffa500;
  color: white;
  font-size:16px;
  font-weight:bold;
}
.knowledge-title {
  margin: 10px 12px 12px 10px;
}
.knowledge-card {
  margin: 10px 12px 12px 12px;
  border: 1px solid #CCC;
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
  font-size:16px;
  font-weight:bold;
}
</style>