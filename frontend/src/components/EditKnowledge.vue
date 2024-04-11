<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';
import { useRoute } from 'vue-router'
import Cookies from 'js-cookie';

import DropFile from './DropFile.vue'

const route = useRoute();

const title = ref("");
const knowledge = ref("");
const files = ref([]);

onMounted(() => {
    getDetail();
});

function dateChange(event) {
    recordDate.value = event
}

function onFileChange(event) {
    files.value = [...event];
}

const getDetail = async () => {
    const id = route.params.id
    try {
        const res = await axios.get(import.meta.env.VITE_APP_API_BASE + `/api/v1/knowledges/${id}`, {
            headers: {
                'access-token' : Cookies.get('accessToken'),
                'client':Cookies.get('client'),
                'uid': Cookies.get('uid')
            }
        })
        console.log({ res })
        title.value = res.data.knowledge[0].title
        knowledge.value = res.data.knowledge[0].knowledge
    } catch (error) {
        console.log({ error })
    }
}
</script>

<template>
    <div class="editor">
        <label class="itemLabel">タイトル</label>
        <input id="title" type="text" v-model="title">
        <textarea name="knowledge" rows="20" v-model="knowledge"></textarea>
    </div>
    <div class="relationImages">
        <p class="inputTitle">関連画像</p>
        <DropFile @change="onFileChange"/>
    </div>
    <div class="relationImages">
        <button class="registerButton" @click="registerRecord">登録する</button>
    </div>
</template>

<style>
.editor{
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
.relationImages {
    padding: 20px;
}
.registerButton{
    background: #ffa500;
    color: white;
    font-size:16px;
    font-weight:bold;
}
</style>