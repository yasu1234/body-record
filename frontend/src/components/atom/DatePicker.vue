<script setup>
import { ref } from 'vue';
import VueDatePicker from '@vuepic/vue-datepicker';
import '@vuepic/vue-datepicker/dist/main.css';
import { format } from 'date-fns';

const props = defineProps({
    date: String
})

const emit = defineEmits(['update:date']);

function updateDate(newDate) {
  emit('update:date', format(newDate, 'yyyy/M/d'));
}

</script>

<template>
    <VueDatePicker
    locale="ja"
    v-model="props.date"
    week-start="0"
    format="yyyy/M/d"
    auto-apply
    :month-change-on-scroll="false"
    :enable-time-picker="false"
    :date="date"
    @update:model-value="updateDate"/>
</template>

<style scoped>
</style>