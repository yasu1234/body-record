<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';
import { useRoute } from 'vue-router'
import Cookies from 'js-cookie';

import DropFile from './DropFile.vue'
import DatePicker from './DatePicker.vue'

const route = useRoute();

const recordDate = ref("");
const memo = ref("");
const files = ref([]);
const imageUrls = ref([]);
const recordId = ref(null);

onMounted(() => {
    getDetail();
});

function dateChange(event) {
    recordDate.value = event
}

function onFileChange(event) {
    files.value = [...event];
}

const deleteImage = async (item) => {
    try {
        const res = await axios.delete(import.meta.env.VITE_APP_API_BASE + '/api/v1/record/image', {
            params: {
                'id': recordId.value,
                'image_id': item.id
            },
            headers: {
                'access-token' : Cookies.get('accessToken'),
                'client':Cookies.get('client'),
                'uid': Cookies.get('uid')
            }
        })
        imageUrls.value = res.data.imageUrls
    } catch (error) {
        console.log({ error })
    }
}

const getDetail = async () => {
    const id = route.params.id
    try {
        const res = await axios.get(import.meta.env.VITE_APP_API_BASE + `/api/v1/records/${id}`, {
            headers: {
                'access-token' : Cookies.get('accessToken'),
                'client':Cookies.get('client'),
                'uid': Cookies.get('uid')
            }
        })
        recordId.value = res.data.record.id
        recordDate.value = res.data.record.date
        memo.value = res.data.record.memo
        imageUrls.value = res.data.imageUrls
    } catch (error) {
        console.log({ error })
    }
}

const edit = async () => {
    try {
        const formData = new FormData();
        formData.append('memo', memo.value);
        formData.append('date', recordDate.value);

        for (const file of files.value) {
            formData.append('images', file);
        }

        const res = await axios.patch(import.meta.env.VITE_APP_API_BASE + `/api/v1/records/${recordId.value}`, formData, {
            headers: {
                'Content-Type': 'multipart/form-data',
                'access-token' : Cookies.get('accessToken'),
                'client':Cookies.get('client'),
                'uid': Cookies.get('uid')
            }
        })
        recordId.value = res.data.record.id
        memo.value = res.data.record.memo
        recordDate.value = res.data.record.date
        imageUrls.value = res.data.imageUrls
    } catch (error) {
        console.log({ error })
    }
}
</script>

<template>
    <div class="edit-time">
        <p class="inputTitle">開始日</p>
        <DatePicker isStart=true :date= recordDate @update:date="dateChange"/>
    </div>
    <div class="editor">
        <textarea name="memo" rows="10" v-model="memo"></textarea>
    </div>
    <div class="thumbnail-container">
        <div class="thumbnail" v-for="item in imageUrls">
            <div class="thumbnail-image">
                <img :src="item.url" alt="">
            </div>
            <div class="thumbnail-actions">
                <button class="delete-button" @click="deleteImage(item)">X</button>
            </div>
        </div>
    </div>
    <div class="relationImages">
        <p class="inputTitle">関連画像</p>
        <DropFile @change="onFileChange"/>
    </div>
    <div class="relationImages">
        <button class="registerButton" @click="edit">編集する</button>
    </div>
</template>

<style>
.edit-time {
    padding-left: 20px;
    padding-right: 20px;
}

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
.thumbnail-container {
    display: flex;
    flex-wrap: wrap;
    justify-content: flex-start;
    padding: 20px;
}
.thumbnail {
    position: relative;
    display: inline-block;
    height: 200px;
    margin-right: 15px;
    margin-bottom: 15px;
    padding-left: 20px;
}
.thumbnail img {
    height: 100%;
}
.thumbnail-image {
    height: 100%;
}
.thumbnail-image img {
    height: 100%;
}
.thumbnail-actions {
    position: absolute;
    top: 5px;
    right: 5px;
}
.delete-button {
    background-color: rgba(255, 255, 255, 0.7);
    border: none;
    color: #000;
    padding: 5px 10px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 12px;
    border-radius: 4px;
    cursor: pointer;
    border-radius: 50%
  }
</style>