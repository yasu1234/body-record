<script setup>
import { ref } from 'vue'

const props = defineProps({
    recordDate: String,
    recordMemo: Number
})

</script>

<template>
    <div class="my-idea-card">
        <h4 class="my-idea-title"><b>{{ props.recordDate }}</b></h4>
        <div>
            <p class="idea-memo">{{ props.recordMemo }}</p>
        </div>
    </div>
</template>

<style>
.my-idea-title {
    margin: 10px 12px 12px 10px;
}
.my-idea-card {
  border: 1px solid #CCC;
  border-radius: 5px;
  width: 100%;
  max-width:600px;
  box-shadow: 0px 1px 3px rgba(0,0,0,.18);
  margin: 0 auto;
  margin-top: 10px;
  margin-bottom: 10px;
}
</style>