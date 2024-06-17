<script setup>
import { ref, computed, onMounted, watch } from "vue";
import MarkdownIt from "markdown-it";

const md = new MarkdownIt();

const props = defineProps(['knowledge']);

const knowledgeTitle = ref("");
const knowledgeContent = ref("");

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
  }
};

const renderedMarkdown = computed(() => {
  var slicedContent = ""
  if (knowledgeContent.value.length > 100) {
    slicedContent = knowledgeContent.value.slice(0, 100) + '...';
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

@media screen and (max-width: 768px) {
  .knowledge-card {
    width: auto;
    margin-left: 20px;
    margin-right: 20px;
  }
}
</style>
