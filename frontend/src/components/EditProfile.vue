<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';
import Cookies from 'js-cookie';

import DropFile from './DropFile.vue'
import Header from './Header.vue'

const goalWeight = ref(null);
const goalFatPercentage = ref(null);
const files = ref([]);
const userThumbnail = ref(null);

function onFileChange(event) {
    files.value = [...event];
}

const registerRecord = async () => {

}
</script>

<template>
    <Header />
    <form @submit.prevent="login">
        <div class="profile-edit-content">
            <label for="goal-weight">目標体重:</label>
            <input type="text" id="goal-weight">
            <label for="goal-weight" class="unit-label">kg</label>
        </div>
        <div class="profile-edit-content">
            <label for="goal-fat-percentage">目標体脂肪率:</label>
            <input type="text" id="goal-fat-percentage">
            <label for="goal-fat-percentage" class="unit-label">%</label>
        </div>
        <div class="profile-area">
            <label for="comments">紹介文</label>
            <textarea id="profile"></textarea>
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

textarea {
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