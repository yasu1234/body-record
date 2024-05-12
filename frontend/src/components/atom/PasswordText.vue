<script setup>
import { ref, onMounted } from 'vue';

import Password from 'primevue/password';

const passwordType = ref(0);

const props = defineProps({
    password: String,
    passwordType: Number
})

const emit = defineEmits(['updatePassword']);

onMounted(() => {
    passwordType.value = props.passwordType
});

function updatePassword(currentText) {
  emit('updatePassword', currentText, passwordType.value);
}

</script>

<template>
    <Password v-model="props.password" :feedback="false" @update:model-value="updatePassword" class="password-text" toggleMask />
</template>

<style scoped>
.password-text {
    display: block;
}
</style>