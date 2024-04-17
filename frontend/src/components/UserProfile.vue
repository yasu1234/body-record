<script setup>
import { ref, onMounted } from 'vue';
import { useRouter, useRoute, onBeforeRouteUpdate } from 'vue-router'
import DatePicker from './DatePicker.vue'
import axios from 'axios';
import Cookies from 'js-cookie';

import Header from './Header.vue'

const route = useRoute();
const router = useRouter();

const profile = ref("");
const userName = ref("");
const file = ref(null);
const isDisplayOnlyOpen = ref(false);
const isLogin = ref(false);

onMounted(() => {
    getProfile();
});

const getProfile = async () => {
    const id = route.params.id
  
    try {
        const res = await axios.get(import.meta.env.VITE_APP_API_BASE + `/api/v1/profiles/${id}`, {
            headers: {
                'access-token' : Cookies.get('accessToken'),
                'client':Cookies.get('client'),
                'uid': Cookies.get('uid'),
      
            }
        })

        profile.value = res.data.profile
        userName.value = res.data.user.name
    } catch (error) {
        console.log({ error })
    }
}

function showProfileEdit() {
}
</script>

<template>
  <Header />
  <div class="profile-card">
    <div class="profile-card__inner">
      <div class="profile-thumb">
        <img v-if="file !== null" :src="file.url" alt="ユーザーアイコン"/>
        <img v-else src="../assets/image/user-placeholder.png" alt="ユーザーアイコン" />
      </div>
      <div class="profile-content">
        <span class="profile-name">{{ userName }}</span>
        <span class="profile-intro">{{ profile }}</span>
      </div>
      <div class="profile-edit">
        <button class="profile-edit-button" @click="profileEdit">プロフィール編集</button>
      </div>
    </div>
  </div>
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

.profile-content span{
  display: block;
}

.profile-name{
  margin-bottom: 3px;
  font-weight: bold;
  text-align: center;
}

.profile-intro{
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
</style>