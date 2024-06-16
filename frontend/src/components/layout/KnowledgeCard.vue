<script setup>
import { computed } from "vue";
import MarkdownIt from "markdown-it";

const props = defineProps({
  knowledgeTitle: String,
  knowledgeContent: String,
});

const md = new MarkdownIt();

const renderedMarkdown = computed(() => {
  return md.render(props.knowledgeContent);
});
</script>

<template>
  <div class="knowledge-card">
    <h4 class="m-2.5">
      <b>{{ props.knowledgeTitle }}</b>
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
