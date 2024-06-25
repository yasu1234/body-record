<template>
  <canvas ref="ChartLine" :height="150"></canvas>
</template>

<script setup>
import Chart from "chart.js/auto";
import { ref, onMounted, watch } from "vue";

const props = defineProps(["data"]);
const ChartLine = ref(null);
let chart;

const options = {
    responsive: true,
    maintainAspectRatio: false,
};

onMounted(() => {
  const canvas = ChartLine.value;
  chart = new Chart(canvas, {
    type: "line",
    data: props.data,
    options: options,
  });
});

watch(props.data, (newData) => {
  if (chart) {
    chart.data = newData;
    chart.update();
  }
});
</script>

<style scoped></style>
