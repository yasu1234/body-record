<script setup>
import { ref, onMounted } from "vue";

const props = defineProps(['record']);

const record = ref(null);

onMounted(() => {
  record.value = props.record;
});

const emit = defineEmits(['recordClick']);

const recordClick = () => {
    emit('recordClick', record);
}
</script>

<template>
  <div v-if="record !== null">
    <div class="my-idea-card" @click="recordClick">
      <h4 class="my-idea-title">
        <b>{{ record.formatted_date }}</b>
      </h4>
      <div>
        <p class="idea-memo">{{ record.memo }}</p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.my-idea-title {
  margin: 10px 12px 12px 10px;
}
.my-idea-card {
  border: 1px solid #ccc;
  border-radius: 5px;
  width: 100%;
  max-width: 600px;
  box-shadow: 0px 1px 3px rgba(0, 0, 0, 0.18);
  margin: 0 auto;
  margin-top: 10px;
  margin-bottom: 10px;
}
.idea-memo {
  margin: 10px 0px 10px 10px;
}
</style>
