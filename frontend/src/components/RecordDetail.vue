<script setup>
import { ref, onMounted, computed } from 'vue';
import axios from 'axios';
import { useRoute, useRouter } from 'vue-router'
import Cookies from 'js-cookie';
import MarkdownIt from 'markdown-it'

import Header from './Header.vue'

const route = useRoute();
const router = useRouter();

const title = ref("");
const memo = ref("");
const imageUrls = ref([]);
const recordId = ref(null);
const recordUserId = ref(0);
const isMyRecord = ref(false);
const isSupport = ref(false);

const md = new MarkdownIt()

const renderedMarkdown = computed(() => {
    if (memo.value !== null && memo.value !== "") {
        return md.render(memo.value)
    }
    return ""
})

onMounted(() => {
    getDetail();
});


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
        memo.value = res.data.record.memo
        isMyRecord.value = res.data.isMyRecord
        imageUrls.value = res.data.imageUrls
        recordUserId.value = res.data.record.user_id
    } catch (error) {
        console.log({ error })
    }
}

const deleteRecord = async () => {
    const id = recordId.value
    try {
        const res = await axios.delete(import.meta.env.VITE_APP_API_BASE + `/api/v1/records/${id}`, {
            headers: {
                'access-token' : Cookies.get('accessToken'),
                'client':Cookies.get('client'),
                'uid': Cookies.get('uid')
            }
        })
        router.push({ name: 'Home'})
    } catch (error) {
        console.log({ error })
    }
}

const supportOn = async () => {
    try {
        const formData = new FormData();
        formData.append('id', recordUserId.value);

        const res = await axios.post(import.meta.env.VITE_APP_API_BASE + `/api/v1/supports`, formData, {
            headers: {
                'Content-Type': 'multipart/form-data',
                'access-token' : Cookies.get('accessToken'),
                'client':Cookies.get('client'),
                'uid': Cookies.get('uid')
            }
        })
        isSupport.value = res.data.isSupport;
    } catch (error) {
        console.log({ error })
    }
}

const supportOff = async () => {
    try {
        const res = await axios.delete(import.meta.env.VITE_APP_API_BASE + `/api/v1/supports/${recordUserId.value}`, {
            headers: {
                'access-token' : Cookies.get('accessToken'),
                'client':Cookies.get('client'),
                'uid': Cookies.get('uid')
            }
        })
        isSupport.value = res.data.isSupport;
    } catch (error) {
        console.log({ error })
    }
}

function supportClick(isSupport) {
    if (isSupport === true) {
        supportOff()
    } else {
        supportOn();
    }
}

function edit() {
    router.push({ name: 'EditRecord', params: { id: recordId.value }})
}
</script>

<template>
    <Header />
    <div class="wrap">
		<div class="main">
			<div class="main_content">
                <div class="editor">
                    <p id="title" class="knowledge-title" type="text"> {{ title }} </p>
                    <p class="knowledge-content" v-html="renderedMarkdown" />
                </div>
                <div v-if="imageUrls.length!==0">
                    <p class="inputTitle">関連画像</p>
                    <div class="thumbnail-container">
                        <div class="thumbnail" v-for="item in imageUrls">
                            <div class="thumbnail-image">
                                <img :src="item.url" alt="">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="record-detail-buttons" v-if="isMyRecord">
                    <button class="detail-button" @click="edit">編集する</button>
                    <button class="detail-button" @click="deleteRecord">削除する</button>
                </div>
			</div>
		</div>
		<div class="side">
			<div class="side_content">
				<button v-if="isSupport" class="booknmark-button"><img src="../assets/image/support_on.png" alt="ユーザー" class="booknmark-image" @click="supportClick(true)"></button>
                <button v-else class="booknmark-button"><img src="../assets/image/support_off.png" alt="ユーザー" class="booknmark-image" @click="supportClick(false)"></button>
			</div>
		</div>
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
.knowledge-title {
    font-weight: bold;
    font-size: 22px;
}
.knowledge-content {
    font-size: 22px;
    padding-top: 20px;
}
.record-detail-buttons {
    padding: 20px;
    display: flex;
    justify-content: center;
}
.record-detail-buttons button {
    margin-right: 15px;
}
.detail-button {
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
</style>