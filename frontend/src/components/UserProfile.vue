<script setup>
import { ref, onMounted } from 'vue';
import { useRouter, useRoute, onBeforeRouteUpdate } from 'vue-router'
import axios from 'axios';
import Cookies from 'js-cookie';

import Header from './Header.vue'
import RecordCard from './RecordCard.vue'
import KnowledgeCard from './KnowledgeCard.vue'
import Chart from './Chart.vue'
import MonthPicker from './MonthPicker.vue'

const route = useRoute();
const router = useRouter();

const profile = ref("");
const userName = ref("");
const userThumbnail = ref(null);
const records = ref([]);
const knowledges = ref([]);
const isLogin = ref(false);
const userId = ref(0);
const month = ref({
  month: new Date().getMonth(),
  year: new Date().getFullYear()
});

onMounted(() => {
    getProfile();
    getUserRecord();
    getUserKnowledge();
    getMonthRecord();
});

var data = ref({
  labels: [],
  datasets: [
    {
      label: "体重",
      data: [],
      borderColor: "rgb(75, 192, 192)",
    },
  ],
});


const getProfile = async () => {
  userId.value = route.params.id
  const id = route.params.id
  
    try {
        const res = await axios.get(import.meta.env.VITE_APP_API_BASE + `/api/v1/profiles/${id}`, {
            headers: {
                'access-token' : Cookies.get('accessToken'),
                'client':Cookies.get('client'),
                'uid': Cookies.get('uid'),
      
            }
        })

        profile.value = res.data.user.profile.profile
        userName.value = res.data.user.name
    } catch (error) {
        console.log({ error })
    }
}

const getUserRecord = async () => {
    const id = route.params.id
  
    try {
        const res = await axios.get(import.meta.env.VITE_APP_API_BASE + `/api/v1/records/user/${id}`, {
            headers: {
                'access-token' : Cookies.get('accessToken'),
                'client':Cookies.get('client'),
                'uid': Cookies.get('uid'),
            }
        })

        records.value = res.data.records
    } catch (error) {
        console.log({ error })
    }
}

const getMonthRecord = async () => {
    const id = route.params.id
  
    try {
        const res = await axios.get(import.meta.env.VITE_APP_API_BASE + `/api/v1/graph_record`, {
            headers: {
                'access-token' : Cookies.get('accessToken'),
                'client':Cookies.get('client'),
                'uid': Cookies.get('uid'),
            },
            params: {
              user_id: id,
              targetYear: month.value.year,
              targetMonth: month.value.month + 1
            }
        })

        console.log({ res })

        data.value.labels = res.data.record.map(record => record.set_formatted_date)
        data.value.datasets[0].data = res.data.record.map(record => record.weight)
    } catch (error) {
        console.log({ error })
    }
}

const getUserKnowledge = async () => {
    const id = route.params.id
  
    try {
        const res = await axios.get(import.meta.env.VITE_APP_API_BASE + `/api/v1/knowledges/user/${id}`, {
            headers: {
                'access-token' : Cookies.get('accessToken'),
                'client':Cookies.get('client'),
                'uid': Cookies.get('uid'),
            }
        })

        knowledges.value = res.data.knowledges
    } catch (error) {
        console.log({ error })
    }
}

function monthChange(event) {
  month.value = event
  getMonthRecord();
}

function showEditProfile() {
  router.push({ name: 'EditProfile', params: { id: userId.value }})
}
</script>

<template>
  <Header />
  <div class="profile-card">
    <div class="profile-card__inner">
      <div class="profile-thumb">
        <img v-if="userThumbnail !== null" :src="userThumbnail.url" alt="ユーザーアイコン"/>
        <img v-else src="../assets/image/user-placeholder.png" alt="ユーザーアイコン" />
      </div>
      <div class="profile-content">
        <span class="profile-name">{{ userName }}</span>
        <span class="profile-intro">{{ profile }}</span>
      </div>
      <div class="profile-edit">
        <button class="profile-edit-button" @click="showEditProfile">プロフィール編集</button>
      </div>
    </div>
  </div>
  <div class="weight-graph">
    <Chart :data="data" />
  </div>
  <MonthPicker :date= month @update:month="monthChange"/>
  <div class="record-list">
    <span class="section-title">投稿した記録</span>
  </div>
  <RecordCard v-for="record in records"
        v-bind="record"
        :recordDate="record.date"
        :recordMemo="record.memo" />
  <div class="record-list">
    <span class="section-title">投稿した知識</span>
  </div>
  <KnowledgeCard v-for="knowledge in knowledges"
        v-bind="knowledge"
        :knowledgeTitle="knowledge.title"
        :knowledgeContent="knowledge.content" />
</template>

<style>
.profile-card{
  width: 100%;
  max-width:400px;
  position: relative;
  box-shadow: 0px 1px 3px rgba(0,0,0,.18);
  overflow: hidden;
  margin: 0 auto;
  margin-top: 15px;
}
.profile-card:before{
 width:120%;
 height:130px;
 content:"";
 transform:skew(15deg,10deg);
 background: #70b7ff;
 position:  absolute;
 top:-15%;
 left:-10%;
 z-index: 0;
}
.profile-card__inner{
 position: relative;
  z-index: 1;
}
.profile-thumb{
  overflow: hidden;
  width: 110px;
  height: 110px;
  border: #fff 3px solid;
  border-radius: 55px;
  margin-left: auto;
  margin-right: auto;
  margin-top: 20px;
}
.profile-thumb img{
  display: block;
  width: 100%;
  height: auto;
}
.profile-content{
  margin: 0 0 49px;
  padding: 15px;
}

.profile-content span {
  display: block;
}

.profile-name {
  margin-bottom: 3px;
  font-weight: bold;
  text-align: center;
}

.profile-intro {
  font-size: 12px;
}

.profile-edit {
  padding-top: 5px;
  padding-bottom: 10px;
  text-align: center;
}

.profile-edit-button {
  background: #ffa500;
  color: white;
  font-size:16px;
  font-weight:bold;
  margin: 0 auto;
}
.record-list {
  text-align: center;
  padding-top: 40px;
}
.section-title {
  border-bottom: solid 5px #ffa500;
  font-size:25px;
  font-weight:bold;
}
.weight-graph {
  margin-top: 20px;
}
</style>