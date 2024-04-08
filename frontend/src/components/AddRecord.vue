<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';

import DatePicker from './DatePicker.vue'
import DropFile from './DropFile.vue'

const content = ref("");
const recordDate = ref("");
const files = ref([]);

function dateChange(event) {
    recordDate.value = event
}

function onFileChange(event) {
    files.value = [...event];
}
</script>

<template>
    <div class="time-list">
        <div class="item">
            <p class="inputTitle">記録日</p>
            <DatePicker isStart=false @startDateChange="dateChange"/>
        </div>
    </div>
    <div class="editor">
        <input type="text" id="Name" name="Name" placeholder="内容" v-model="content">
    </div>
    <div class="relationImages">
        <p class="inputTitle">関連画像</p>
        <DropFile @change="onFileChange"/>
    </div>
    <div class="relationImages">
        <button class="registerButton" @click="register">登録する</button>
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