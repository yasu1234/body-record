<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';
import { useRoute, useRouter } from 'vue-router'
import Cookies from 'js-cookie';
import Toast from "primevue/toast";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../const/toast.js";

import DropFile from '../atom/DropFile.vue'
import DatePicker from '../atom/DatePicker.vue'
import Header from '../layout/Header.vue'

const route = useRoute();
const router = useRouter();
const toast = useToast();
const toastNotifications = new toastService(toast);

const recordDate = ref("");
const memo = ref("");
const weight = ref(null);
const fatPercentage = ref(null);
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

const showNotFound = () =>  {
    router.push({ name: 'NotFound'})
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
        if (error.response.status === 404) {
            showNotFound()
        }
    }
}

const edit = async () => {
    try {
        const formData = new FormData();
        formData.append('record[memo]', memo.value);
        formData.append('record[date]', recordDate.value);
        if (weight.value !== null) {
            formData.append('record[weight]', weight.value);
        }
        if (fatPercentage.value !== null) {
            formData.append('record[fat_percentage]', fatPercentage.value);
        }

        for (const file of files.value) {
            formData.append('record[images]', file);
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
        if (error.response.status === 404) {
            showNotFound()
        } else {
            let errorMessages = "";
            if (error.response.status === 422) {
                if (Array.isArray(error.response.data.errors)) {
                    errorMessages += error.response.data.errors.join('\n');
                }
            }
            toastNotifications.displayError("記録の更新に失敗しました", errorMessages)
        }
    }
}
</script>

<template>
    <Header />
    <Toast position="top-center" />
    <div class="edit-time">
        <p class="inputTitle">開始日</p>
        <DatePicker isStart=true :date= recordDate @update:date="dateChange"/>
    </div>
    <div class="profile-edit-content">
        <label for="goal-weight">体重:</label>
        <input type="text" id="goal-weight" v-model="weight">
        <label for="goal-weight" class="unit-label">kg</label>
    </div>
    <div class="profile-edit-content">
        <label for="goal-fat-percentage">体脂肪率:</label>
        <input type="text" v-model="fatPercentage">
        <label for="goal-fat-percentage" class="unit-label">%</label>
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

<style scoped>
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
