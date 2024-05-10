<script setup>
import Message from 'primevue/message';
import 'primevue/resources/themes/md-light-indigo/theme.css';

const prop = defineProps(['errorMessage'])

</script>

<template>
    <Message severity="error" v-show="prop.errorMessage !== ''" class="error-message" :closable="false">{{ prop.errorMessage }}</Message>
</template>

<style scoped>
.error-message {
    white-space:pre-wrap; 
    word-wrap:break-word;
}
</style>