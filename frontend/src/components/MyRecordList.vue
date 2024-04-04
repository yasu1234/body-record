<script setup>
import { ref } from 'vue';
import DatePicker from './DatePicker.vue'

const keyword = ref("");

</script>

<template>
    <div class="keyword-search">
        <input type="text" id="keyword" name="Nkeywordame" placeholder="キーワードで検索" v-model="keyword">
    </div>
    <div class="time-list">
        <div class="item">
            <p class="inputTitle">開始日</p>
            <DatePicker isStart=true  @startDateChange="startDateChange"/>
        </div>
        <div class="item">
            <p class="inputTitle">終了日</p>
            <DatePicker isStart=false  @endDateChange="endDateChange"/>
        </div>
    </div>
    <div class="search-check">
        <!-- <v-checkbox
            v-model="isMyGoal"
            label="非公開記録は表示しない" 
            color="#0000ff"
            @change="changeIsMyGoal(isMyGoal)" /> -->
            <input type="checkbox" id="statusSelect">
            <label for="statusSelectName">非公開記録は表示しない</label>
    </div>
    <div class="search-button-area">
        <button class="search-button" @click="search">検索</button>
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
</style>