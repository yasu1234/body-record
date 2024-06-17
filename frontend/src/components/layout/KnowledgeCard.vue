<script setup>
import { ref, computed, onMounted, watch } from "vue";
import MarkdownIt from "markdown-it";

const md = new MarkdownIt();

const props = defineProps(["knowledge"]);

const knowledgeTitle = ref("");
const knowledgeContent = ref("");
const bookmarkCount = ref(0);
const isMyBookmark = ref(false);

onMounted(() => {
  setProps(props.knowledge);
});

watch(props, () => {
  setProps(props.knowledge);
});

const setProps = (knowledge) => {
  knowledgeTitle.value = "";
  knowledgeContent.value = "";

  if (knowledge != null) {
    knowledgeTitle.value = knowledge.title;
    knowledgeContent.value = knowledge.content;
    bookmarkCount.value = knowledge.bookmark_count;
    isMyBookmark.value = knowledge.is_bookmark;
  }
};

const renderedMarkdown = computed(() => {
  var slicedContent = "";
  if (knowledgeContent.value.length > 100) {
    slicedContent = knowledgeContent.value.slice(0, 100) + "...";
  } else {
    slicedContent = knowledgeContent.value;
  }
  return md.render(slicedContent);
});
</script>

<template>
  <div class="knowledge-card">
    <h4 class="m-2.5">
      <b>{{ knowledgeTitle }}</b>
    </h4>
    <div>
      <p class="knowledge-content" v-html="renderedMarkdown" />
    </div>
    <div class="bookmark-container mt-5 ml-5 pb-5">
      <div v-if="isMyBookmark" class="round-bookamark">
        <img
          src="../../assets/image/bookmark_on.png"
          alt="サポート中"
          class="bookmark-image"
        />
      </div>
      <div v-else class="round-bookamark">
        <img
          src="../../assets/image/bookmark_off.png"
          alt="未サポート"
          class="bookmark-image"
        />
      </div>
      <p class="ml-2.5">{{ bookmarkCount }}</p>
    </div>
  </div>
</template>

<style scoped>
.knowledge-card {
  margin: 2em auto;
  position: relative;
  background: #eee;
  padding: 3em 1em 2em;
  width: 100%;
  max-width: 600px;
  cursor: pointer;
}
.knowledge-card::before {
  position: absolute;
  content: "";
  width: 95%;
  height: 10px;
  top: 0.5em;
  left: 0;
  right: 0;
  bottom: 0;
  margin: 0 auto;
  border-top: dotted 10px #fff; /*ドットの形・大きさ・色*/
}
.knowledge-content {
  margin: 10px 0px 10px 10px;
}
.bookmark-container {
  display: flex;
  align-items: center;
}
.round-bookamark {
  width: 50px;
  height: 50px;
  background: transparent;
  border: 1px solid #ccc;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
}
.bookmark-image {
  width: 100%;
  height: auto;
}

@media screen and (max-width: 768px) {
  .knowledge-card {
    width: auto;
    margin-left: 20px;
    margin-right: 20px;
  }
}
</style>
