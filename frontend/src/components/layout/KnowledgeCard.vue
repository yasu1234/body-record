<script setup>
import { ref, computed } from 'vue'
import MarkdownIt from 'markdown-it'

const props = defineProps({
    knowledgeTitle: String,
    knowledgeContent: String
})

const md = new MarkdownIt()

const renderedMarkdown = computed(() => {
  return md.render(props.knowledgeContent)
})

</script>

<template>
    <div class="knowledge-card">
        <h4 class="knowledge-title"><b>{{ props.knowledgeTitle }}</b></h4>
        <div>
            <p class="knowledge-content" v-html="renderedMarkdown" />
        </div>
    </div>
</template>

<style>
.knowledge-title {
    margin: 10px 12px 12px 10px;
}
.knowledge-card {
  border: 1px solid #CCC;
  border-radius: 5px;
  width: 100%;
  max-width:600px;
  box-shadow: 0px 1px 3px rgba(0,0,0,.18);
  margin: 0 auto;
  margin-top: 20px;
  margin-bottom: 20px;
}
.knowledge-content {
  margin: 10px 0px 10px 10px;
}
</style>