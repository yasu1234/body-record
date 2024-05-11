<script setup>
import { ref, onMounted } from 'vue';
import { useRouter, onBeforeRouteUpdate } from 'vue-router'
import axios from 'axios';
import Cookies from 'js-cookie';

import ListPage from '../layout/ListPage.vue'
import DatePicker from '../atom/DatePicker.vue'

const router = useRouter();

const keyword = ref("");
const startDate = ref("");
const endDate = ref("");
const isDisplayOnlyOpen = ref(false);
const isLogin = ref(false);
const searchResult = ref([]);

const pageCount = ref(1);
const pageNum = ref(1);

onMounted(() => {
  search();
});

onBeforeRouteUpdate(async (to, from) => {
  keyword.value = to.query.keyword;
  startDate.value = to.query.startDate;
  endDate.value = to.query.endDate;
  search();
});

const targetSearch = ()=> {
  const query = {};

  if (keyword.value.trim() !== '') {
    query.keyword = keyword.value;
  }

  if (startDate.value !== '') {
    query.startDate = startDate.value;
  }

  if (endDate.value !== '') {
    query.endDate = endDate.value;
  }

  router.push( {path: '/', query: query});
}

const search = async () => {
  try {
    const res = await axios.get(import.meta.env.VITE_APP_API_BASE + '/api/v1/myRecord', {
      headers: {
        'access-token' : Cookies.get('accessToken'),
        'client':Cookies.get('client'),
        'uid': Cookies.get('uid'),
      },
      params: {
        keyword: keyword.value,
        startDate: startDate.value,             
        endDate: endDate.value,
        page: pageNum
      }
    })

    if (res.data && res.data.totalPage) {
      pageCount.value = res.data.totalPage
    } else {
      pageCount.value = 1
    }

    searchResult.value = [];
    
    for(let item of res.data.records){
      searchResult.value.push(item);
    }
  } catch (error) {
    searchResult.value = [];
  }
}

const updatePaginateItems = function (page) {
  pageNum.value = page
  search();
};

function startDateChange(event) {
  startDate.value = event
}

function endDateChange(event) {
  endDate.value = event
}

function clickRecord(item) {
  router.push({ name: 'RecordDetail', params: { id: item.id }})
}

function addRecord() {
  router.push('/addRecord');
}
</script>

<template>
    <div class="keyword-search">
        <input type="text" id="keyword" name="keywordName" placeholder="キーワードで検索" v-model="keyword">
    </div>
    <div class="time-list">
        <div class="item">
            <p class="inputTitle">開始日</p>
            <DatePicker isStart=true :date= startDate @update:date="startDateChange"/>
        </div>
        <div class="item">
            <p class="inputTitle">終了日</p>
            <DatePicker isStart=false :date= endDate @update:date="endDateChange"/>
        </div>
    </div>
    <div class="search-check">
      <input type="checkbox" id="statusSelect" v-model="isDisplayOnlyOpen">
      <label for="statusSelectName">非公開記録は表示しない</label>
    </div>
    <div class="search-button-area">
        <button class="search-button" @click="targetSearch">検索</button>
    </div>
    <div class="add-button-area">
        <button class="add-button" @click="addRecord">記録を追加する</button>
    </div>
    <div class="my-idea-card" v-for="item of searchResult" :key="item.id" @click="clickRecord(item)">
      <h4 class="my-idea-title"><b>{{ item.date }}</b></h4>
      <div>
        <p class="idea-memo">{{ item.memo }}</p>
      </div>
    </div>
    <div class="record-list-page">
      <ListPage
      :pageCount="pageCount"
      v-model="pageNum"
      @changePage="updatePaginateItems" />
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
.time-list {
  display: flex;
  justify-content: space-between;
  padding-left: 30px;
  padding-right: 30px;
}
.time-list .item {
  width: 50%;
  margin: 0;
  padding: 10px;
  box-sizing: border-box;
}
.time-list .item .inputTitle {
  margin: 5px 0 0;
  padding: 0;
  font-size: 16px;
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
.my-idea-title {
  margin: 10px 12px 12px 10px;
}
.my-idea-card {
  margin: 10px 12px 12px 12px;
  border: 1px solid #CCC;
  border-radius: 5px;
}
.idea-memo {
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
.record-list-page {
  margin-top: 50px;
}
</style>