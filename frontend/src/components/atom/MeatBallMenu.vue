<template>
  <div class="meatball-menu">
    <div v-for="i in 3" class="dot" />
  </div>
</template>

<script setup></script>

<style scoped>
.meatball-menu {
  width: 20px;
  height: 10px;
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  cursor: pointer;
}
.dot {
  width: 3px;
  height: 3px;
  background-color: #333;
  border-radius: 50%;
}
</style>
