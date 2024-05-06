<script setup>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router'
import axios from 'axios';
import Cookies from 'js-cookie';

import DropFile from '../DropFile.vue'
import Header from '../Header.vue'

const route = useRoute();

const goalWeight = ref(null);
const goalFatPercentage = ref(null);
const profile = ref('');
const file = ref(null);
const userThumbnail = ref(null);
const userId = ref(0);

function onFileChange(event) {
    file.value = event[0];
}

onMounted(() => {
    getProfile();
});

const getProfile = async () => {
  userId.value = route.params.id
  const id = route.params.id
  
    try {
        const res = await axios.get(import.meta.env.VITE_APP_API_BASE + `/api/v1/profiles/${id}`, {
            headers: {
                'access-token' : Cookies.get('accessToken'),
                'client':Cookies.get('client'),
                'uid': Cookies.get('uid')
            }
        })

        if (res.data.user.profile.goal_weight !== null) {
            goalWeight.value = res.data.user.profile.goal_weight
        }

        if (res.data.user.profile.goal_fat_percentage !== null) {
            goalFatPercentage.value = res.data.user.profile.goal_fat_percentage
        }

        if (res.data.user.profile.profile !== null) {
            profile.value = res.data.user.profile.profile
        }
    } catch (error) {
        console.log({ error })
    }
}

const updateProfile = async () => {
    try {
        const formData = new FormData();
        formData.append('profile', profile.value);
        formData.append('goal_weight', goalWeight.value);
        formData.append('goal_fat_percentage', goalFatPercentage.value);

        if (file.value !== null) {
            formData.append('image', file.value);
        }

        const res = await axios.post(import.meta.env.VITE_APP_API_BASE + `/api/v1/profiles`, formData, {
            headers: {
                'Content-Type': 'multipart/form-data',
                'access-token' : Cookies.get('accessToken'),
                'client':Cookies.get('client'),
                'uid': Cookies.get('uid')
            }
        })
        
    } catch (error) {
        console.log({ error })
    }
}
</script>

<template>
    <Header />
    <form @submit.prevent="updateProfile">
        <div class="profile-edit-content">
            <label for="goal-weight">目標体重:</label>
            <input type="text" id="goal-weight" v-model="goalWeight">
            <label for="goal-weight" class="unit-label">kg</label>
        </div>
        <div class="profile-edit-content">
            <label for="goal-fat-percentage">目標体脂肪率:</label>
            <input type="text" v-model="goalFatPercentage">
            <label for="goal-fat-percentage" class="unit-label">%</label>
        </div>
        <div class="profile-area">
            <label for="comments">紹介文</label>
            <textarea v-model="profile" class="profile-text" />
        </div>
        <div class="profile-image-change-container">
            <label>プロフィール画像変更</label>
            <div class="current-thumbnail">
                <img v-if="userThumbnail !== null" :src="userThumbnail.url" alt="ユーザーアイコン"/>
                <img v-else src="../assets/image/user-placeholder.png" alt="ユーザーアイコン" />
            </div>
            <DropFile @change="onFileChange" />
        </div>
        <button class="edit-profile-button">更新する</button>
    </form>
</template>

<style>
form {
    margin-left: 15px;
}

.profile-edit-content {
    display: flex;
    align-items: center;
    margin-top: 20px;
}

input[type="text"] {
    padding: 5px;
    border: 1px solid #ccc;
    border-radius: 3px;
    font-size: 16px;
    width: 100px;
    margin-left: 10px;
}

.unit-label {
    margin-left: 10px;
}

.profile-text {
    width: 60%;
    height: 100px;
}

.profile-area {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    margin-top: 20px;
}

.profile-area label {
    margin-bottom: 5px;
}

.edit-profile-button {
    background: #ffa500;
    color: white;
    font-size:16px;
    font-weight:bold;
    cursor: pointer;
    display: block;
    width: 180px;
    margin: 0 auto;
    margin-top: 30px;
}
.profile-image-change-container {
    margin-top:20px;
}

.current-thumbnail {
    width: 80px;
    height: 80px;
    border: #CCC 1px solid;
    border-radius: 55px;
    margin-top: 20px;
    margin-bottom: 20px;
}

.current-thumbnail img {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
  border-radius: 50%;
}
</style>