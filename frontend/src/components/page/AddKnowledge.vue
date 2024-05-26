<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from "vue-router";
import axios from 'axios';
import Cookies from 'js-cookie';
import Toast from "primevue/toast";
import { useToast } from "primevue/usetoast";
import { toastService } from "../../const/toast.js";
import FloatLabel from "primevue/floatlabel";
import InputText from "primevue/inputtext";
import Textarea from "primevue/textarea";

import DropFile from '../atom/DropFile.vue'
import Header from '../layout/Header.vue'

const router = useRouter();
const toast = useToast();
const toastNotifications = new toastService(toast);

const title = ref('');
const knowledge = ref('');
const files = ref([]);

function onFileChange(event) {
    files.value = [...event];
}

const registerKnowledge = async () => {
    try {
        const formData = new FormData();
        formData.append('knowledge[title]', title.value);
        formData.append('knowledge[content]', knowledge.value);

        for (const file of files.value) {
            formData.append('knowledge[images]', file);
        }

        const res = await axios.post(import.meta.env.VITE_APP_API_BASE + '/api/v1/knowledges', formData, {
            headers: {
                'Content-Type': 'multipart/form-data',
                'access-token' : Cookies.get('accessToken'),
                'client':Cookies.get('client'),
                'uid': Cookies.get('uid')
            }
        })
        toastNotifications.displayInfo("登録しました", "");
        setTimeout(async () => {
            showKnowledgeDetail(res.data.knowledge);
        }, 3000);
    } catch (error) {
        let errorMessages = '';
        if (error.response.status === 422) {
            if (Array.isArray(error.response.data.errors)) {
                errorMessages += error.response.data.errors.join('\n');
            }
        }
        toastNotifications.displayError("ノウハウの追加に失敗しました", errorMessages);
    }
}

const showKnowledgeDetail = (item) => {
    router.push({ name: 'KnowledgeDetail', params: { id: item.id }})
}
</script>

<template>
    <Header />
    <Toast position="top-center" />
    <div class="editor">
        <FloatLabel>
            <InputText v-model="title" class="input-width" />
            <label>タイトル</label>
        </FloatLabel>
        <FloatLabel>
            <Textarea v-model="knowledge" rows="20" class="input-width" />
            <label>詳細</label>
        </FloatLabel>
    </div>
    <div class="relationImages">
        <p class="inputTitle">関連画像</p>
        <DropFile @change="onFileChange"/>
    </div>
    <div class="relationImages">
        <button class="add-knowledge-button" @click="registerKnowledge">登録する</button>
    </div>
</template>

<style scoped>
.editor{
   padding: 30px;
 }
 .input-width {
    width: 100%;
    padding: 12px 12px;
    margin: 8px 0;
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
.add-knowledge-button{
    font-size:16px;
    font-weight:bold;
}
</style>
