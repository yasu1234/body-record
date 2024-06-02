<script setup>
import { ref, onMounted } from "vue";
import VueDatePicker from "@vuepic/vue-datepicker";
import "@vuepic/vue-datepicker/dist/main.css";
import { format } from "date-fns";

const date = ref('');

const props = defineProps({
  date: String,
});

const emit = defineEmits(["update:date"]);

onMounted(() => {
  date.value = props.date;
});

function updateDate(newDate) {
  if (newDate !== null) {
    emit("update:date", format(newDate, "yyyy/M/d"));
  } else {
    emit("update:date", "");
  }
}
</script>

<template>
  <VueDatePicker
    locale="ja"
    v-model="date"
    week-start="0"
    format="yyyy/M/d"
    auto-apply
    :month-change-on-scroll="false"
    :enable-time-picker="false"
    :date="date"
    @update:model-value="updateDate"
  />
</template>

<style scoped></style>
