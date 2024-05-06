<script setup>
import { ref } from 'vue'

const props = defineProps({
    menuTitle: String,
    menuId: Number,
    currentId: Number
})

const emit = defineEmits(['menuTapped']);

function handleClick(menuId) {
    emit('menuTapped', menuId);
}
</script>

<template>
    <div>
        <button @click="handleClick(props.menuId)" class="tab-button" :class="[props.currentId === props.menuId ? 'active' : '', 'tab']">
            {{props.menuTitle}}
        </button>
        <div class="active-tab" v-if="props.currentId === props.menuId"></div>
    </div>
</template>

<style>
.tab {
  border-radius: 2px 2px 0 0;
  background: #fff;
  color: #867d74;
  line-height: 24px;
}
.tab-button {
    margin-left: 8px;
    margin-right: 8px;
}
.tab:hover {
  color: #000000;
}
.active {
    color: #867d74;
}
.active-tab {
    height: 4px;
    background: #ffa500;
}
</style>