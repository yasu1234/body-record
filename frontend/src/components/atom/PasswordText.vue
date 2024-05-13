<script setup>
import { ref, onMounted } from 'vue';

import Password from 'primevue/password';

const passwordType = ref(0);
const password = ref('');

const props = defineProps({
    password: String,
    passwordType: Number
})

const emit = defineEmits(['updatePassword']);

onMounted(() => {
    passwordType.value = props.passwordType
    password.value = props.password
});

function updatePassword(currentText) {
  emit('updatePassword', currentText, passwordType.value);
}

</script>

<template>
    <Password v-model="password" :feedback="false" @update:model-value="updatePassword" class="password-text" toggleMask />
</template>

<style scoped>
.password-text {
    display: block;
}
:deep input[type="password"] {
    padding: 10px;
    width: 100%;
}
</style>