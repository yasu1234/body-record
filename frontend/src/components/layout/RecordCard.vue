<template>
  <div v-if="record !== null">
    <div class="my-idea-card" @click="recordClick">
      <h4 class="mt-2.5 mx-3">
        <b>{{ record.formatted_date }}の記録</b>
      </h4>
      <div>
        <p class="mt-2.5 mb-2.5 mx-3">{{ recordMemo }}</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from "vue";

const props = defineProps(["record"]);

const record = ref(null);
const recordMemo = ref('');

onMounted(() => {
  record.value = props.record;
  memoTrim(props.record.memo);
});

watch(props, () => {
  record.value = props.record;
  memoTrim(props.record.memo);
});

const emit = defineEmits(["record-click"]);

const memoTrim = (memo) => {
  if (memo == null) {
    recordMemo.value = '';
    return
  }

  if (memo.length > 50) {
    recordMemo.value = memo.slice(0, 50) + '...';
  } else {
    recordMemo.value = memo;
  }
}

const recordClick = () => {
  emit("record-click", record);
};
</script>

<style scoped>
.my-idea-card {
  width: 100%;
  max-width: 600px;
  padding: 0.5em 1em;
  margin: 0 auto;
  margin-bottom: 20px;
  margin-top: 10px;
  position: relative;
  background: #fff0cd;
  box-shadow: 0px 0px 0px 5px #fff0cd;
  border: dashed 2px white;
  padding: 0.2em 0.5em;
  color: #454545;
  cursor: pointer;
}
.my-idea-card:after {
  position: absolute;
  content: "";
  right: -7px;
  top: -7px;
  border-width: 0 15px 15px 0;
  border-style: solid;
  border-color: #ffdb88 #fff #ffdb88;
  box-shadow: -1px 1px 1px rgba(0, 0, 0, 0.15);
}

@media screen and (max-width: 768px) {
  .my-idea-card {
    width: auto;
    margin-left: 20px;
    margin-right: 20px;
  }
}
</style>
