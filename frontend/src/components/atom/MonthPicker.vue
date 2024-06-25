<template>
  <VueDatePicker
    locale="ja"
    v-model="props.date"
    month-picker
    week-start="0"
    format="yyyy/M"
    auto-apply
    v-bind:clearable="false"
    :month-change-on-scroll="false"
    :enable-time-picker="false"
    :date="date"
    @update:model-value="updateMonth"
  />
</template>

<script setup>
import VueDatePicker from "@vuepic/vue-datepicker";
import "@vuepic/vue-datepicker/dist/main.css";

const props = defineProps(["date"]);

const emit = defineEmits(["update:month"]);

const updateMonth = (newMonth) => {
  emit("update:month", newMonth);
}
</script>

<style scoped></style>
