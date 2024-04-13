<script setup>
import { ref, onMounted, computed } from 'vue';
import axios from 'axios';
import { useRoute, useRouter } from 'vue-router'
import Cookies from 'js-cookie';
import MarkdownIt from 'markdown-it'

const route = useRoute();
const router = useRouter();

const title = ref("");
const knowledge = ref("");
const imageUrls = ref([]);
const knowledgeId = ref(null);

const md = new MarkdownIt()

const renderedMarkdown = computed(() => {
  return md.render(knowledge.value)
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
        knowledgeId.value = res.data.knowledge.id
        title.value = res.data.knowledge.title
        knowledge.value = res.data.knowledge.content
        imageUrls.value = res.data.imageUrls
    } catch (error) {
        console.log({ error })
    }
}

function edit() {
    router.push({ name: 'EditKnowledge', params: { id: knowledgeId.value }})
}
</script>

<template>
    <div class="editor">
        <p id="title" class="knowledge-title" type="text"> {{ title }} </p>
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
</style>