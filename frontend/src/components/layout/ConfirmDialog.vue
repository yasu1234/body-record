<template>
  <div class="modal-container">
    <div class="modal-header">
      <slot name="header">{{ title }}</slot>
    </div>
    <div class="modal-body">
      <slot name="body"
        ><p class="dialog-message">{{ message }}</p></slot
      >
    </div>
    <div class="text-right">
      <slot name="footer">
        <button
          class="positive-button mr-2.5 py-2.5 px-5"
          @click="handlePositive"
        >
          {{ positiveButtonTitle }}
        </button>
        <button class="cancel-button py-2.5 px-5" @click="cancel">
          キャンセル
        </button>
      </slot>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";

const title = ref("");
const message = ref("");
const positiveButtonTitle = ref("");

const props = defineProps(["title", "message", "positiveButtonTitle"]);

const emit = defineEmits(["handle-positive", "cancel"]);

onMounted(() => {
  title.value = props.title;
  message.value = props.message;
  positiveButtonTitle.value = props.positiveButtonTitle
});

const handlePositive = () => {
  emit("handle-positive");
};

const cancel = () => {
  emit("cancel");
};
</script>

<style scoped>
.dialog-message {
  white-space: pre-line;
}
.positive-button {
  background: #d50c05;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
}
.cancel-button {
  background: #fff;
  color: #000000;
  border: 1px solid #ccc;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
}
.modal-container {
  background-color: #fff;
  border-radius: 5px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.33);
  padding: 20px;
  width: 500px;
}
.modal-header {
  margin-top: 0;
  font-size: 20px;
}
.modal-body {
  margin: 20px 0;
  line-height: 1.6;
}

@media (max-width: 768px) {
  .modal-container {
    margin-left: 10px;
    margin-right: 10px;
    width: 100%;
  }
}
</style>
