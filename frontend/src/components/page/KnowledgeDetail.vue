<script setup>
import { ref, onMounted, computed } from 'vue';
import axios from 'axios';
import { useRoute, useRouter } from 'vue-router'
import Cookies from 'js-cookie';
import MarkdownIt from 'markdown-it'

import Header from '../Header.vue'

const route = useRoute();
const router = useRouter();

const knowledge = ref(null);
const imageUrls = ref([]);
const knowledgeId = ref(null);
const isBookmark = ref(false);
const comments = ref([]);
const comment = ref('');

const md = new MarkdownIt()

const renderedMarkdown = computed(() => {
    if (knowledge.value && knowledge.value.content) {
        return md.render(knowledge.value.content);
    }
    return '';
})

onMounted(() => {
    getDetail();
});

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
        knowledgeId.value = res.data.knowledge.id
        knowledge.value = res.data.knowledge
        imageUrls.value = res.data.knowledge.image_urls
        isBookmark.value = res.data.isBookmark
        comments.value = res.data.knowledge.comments
    } catch (error) {
        console.log({ error })
    }
}

const bookmarkOn = async () => {
    try {
        const formData = new FormData();
        formData.append('bookmark[knowledge_id]', knowledgeId.value);

        const res = await axios.post(import.meta.env.VITE_APP_API_BASE + `/api/v1/bookmarks`, formData, {
            headers: {
                'Content-Type': 'multipart/form-data',
                'access-token' : Cookies.get('accessToken'),
                'client':Cookies.get('client'),
                'uid': Cookies.get('uid')
            }
        })
        knowledge.value = res.data.knowledge
        isBookmark.value = res.data.isBookmark
    } catch (error) {
        console.log({ error })
    }
}

const bookmarkOff = async () => {
    try {
        const res = await axios.delete(import.meta.env.VITE_APP_API_BASE + `/api/v1/bookmarks/${knowledgeId.value}`, {
            headers: {
                'access-token' : Cookies.get('accessToken'),
                'client':Cookies.get('client'),
                'uid': Cookies.get('uid')
            }
        })
        knowledge.value = res.data.knowledge
        isBookmark.value = res.data.isBookmark
    } catch (error) {
        console.log({ error })
    }
}

function bookmarkClick(isBookmarkOn) {
    if (isBookmarkOn === true) {
        bookmarkOff()
    } else {
        bookmarkOn();
    }
}

const addComment = async () => {
    try {
        const formData = new FormData();
        formData.append('knowledge_id', knowledgeId.value);
        formData.append('comment', comment.value);

        const res = await axios.post(import.meta.env.VITE_APP_API_BASE + `/api/v1/comments/knowledge`, formData, {
            headers: {
                'access-token' : Cookies.get('accessToken'),
                'client':Cookies.get('client'),
                'uid': Cookies.get('uid')
            }
        })
        comments.value = res.data.knowledge.comments
    } catch (error) {
        console.log({ error })
    }
}

function edit() {
    router.push({ name: 'EditKnowledge', params: { id: knowledgeId.value }})
}
</script>

<template>
    <Header />
    <div class="wrap">
		<div class="main">
			<div class="main_content">
                <div class="editor">
                    <p id="title" class="knowledge-title" type="text" v-if="knowledge !== null"> {{ knowledge.title }} </p>
                    <p class="knowledge-content" v-html="renderedMarkdown"></p>
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
                <div class="relationImages">
                    <button class="editButton" @click="edit">編集する</button>
                </div>
                <div class="comment-container">
                    <div class="comment-container-title-area">
                        <p class="comment-container-title">コメント</p>
                    </div>
                    <div v-for="comment in comments">
                        <p> {{ comment.comment }} </p>
                    </div>
                    <textarea name="comment" rows="15" v-model="comment" class="comment-textarea" />
                    <button class="registerButton" @click="addComment">コメントを投稿する</button>
                </div>
			</div>
		</div>
		<div class="side">
			<div class="side_content">
				<button v-if="isBookmark" class="booknmark-button"><img src="../assets/image/bookmark_on.png" alt="ユーザー" class="booknmark-image" @click="bookmarkClick(true)"></button>
                <button v-else class="booknmark-button"><img src="../assets/image/bookmark_off.png" alt="ユーザー" class="booknmark-image" @click="bookmarkClick(false)"></button>
			</div>
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