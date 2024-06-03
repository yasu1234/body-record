<script setup>
import { ref, onMounted, watch } from "vue";

const props = defineProps(["record"]);

const record = ref(null);

onMounted(() => {
  record.value = props.record;
});

watch(props, () => {
  record.value = props.record;
});

const emit = defineEmits(["recordClick"]);

const recordClick = () => {
  emit("recordClick", record);
};
</script>

<template>
  <div v-if="record !== null">
    <div class="my-idea-card" @click="recordClick">
      <h4 class="my-idea-title">
        <b>{{ record.formatted_date }}の記録</b>
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
.idea-memo {
  margin: 10px 0px 10px 10px;
}

@media screen and (max-width: 768px) {
  .my-idea-card {
    width: auto;
    margin-left: 20px;
    margin-right: 20px;
  }
}
</style>
