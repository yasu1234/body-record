<script setup>
import { ref, onMounted, computed } from 'vue';
import axios from 'axios';
import { useRoute, useRouter } from 'vue-router'
import Cookies from 'js-cookie';

import Header from '../Header.vue'

const route = useRoute();
const router = useRouter();

const contact = ref(null);

onMounted(() => {
    getDetail();
});

const getDetail = async () => {
    const id = route.params.id
    try {
        const res = await axios.get(import.meta.env.VITE_APP_API_BASE + `/api/v1/contacts/${id}`, {
            headers: {
                'access-token' : Cookies.get('accessToken'),
                'client':Cookies.get('client'),
                'uid': Cookies.get('uid')
            }
        })
        contact.value = res.data.contact
    } catch (error) {
        console.log({ error })
    }
}

const statusChange = async (isComplete) => {
    try {
        const formData = new FormData();
        if (isComplete) {
            formData.append('status', null);
        } else {
            formData.append('status', 1);
        }

        const res = await axios.put(import.meta.env.VITE_APP_API_BASE + `/api/v1/contacts/${contact.value.id}`, formData, {
            headers: {
                'access-token' : Cookies.get('accessToken'),
                'client':Cookies.get('client'),
                'uid': Cookies.get('uid')
            }
        })
        contact.value = res.data.contact
    } catch (error) {
        console.log({ error })
    }
}
</script>

<template>
    <Header />
	<div v-if="contact !== null">
        <div class="editor">
            <p id="title" class="knowledge-title" type="text"> {{ contact.content }} </p>
        </div>
        <div class="relationImages">
            <button class="editButton" v-if="contact.status === 1" @click="statusChange(true)">対応中に戻す</button>
            <button class="editButton" v-else @click="statusChange(false)">対応済にする</button>
        </div>
	</div>
</template>

<style>
.wrap {
    display: grid;	
    grid-template-columns: 4fr 1fr;
}
.side_content {
	position: sticky;
	top: 100px;
}

.booknmark-button {
	padding: 0;
    background: transparent;
    border: 1px solid #CCC;
    border-radius: 50%;
}
.booknmark-image {
    width: 40px;
    height: 40px;
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
.knowledge-title {
    font-weight: bold;
    font-size: 22px;
}
.knowledge-content {
    font-size: 22px;
    padding-top: 20px;
}
.relationImages {
    padding: 20px;
}
.editButton{
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
.comment-container {
    margin-top: 20px;
    margin-left: 20px;
}
.comment-container-title-area {
    border-bottom: 1px solid rgba(6, 6, 6, 0.17);
}

.comment-textarea {
    width: 100%;
    margin-top: 20px;
}

.comment-container-title {
    text-align: left;
}
</style>