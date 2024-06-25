<template>
  <div class="main">
    <div
      class="dropzone-container"
      @dragover="dragover"
      @dragleave="dragleave"
      @drop="drop"
    >
      <input
        type="file"
        name="file"
        :id="`fileInput-${index}`"
        class="hidden-input"
        @change="onChange"
        @click="
          (e) => {
            e.target.value = '';
          }
        "
        accept=".pdf,.jpg,.jpeg,.png"
      />
      <label :for="`fileInput-${index}`" class="file-label">
        <div v-if="isDragging">Release to drop files here.</div>
        <div v-else>
          ファイルをドロップ、もしくは<u>こちらをクリックして</u>アップロードしてください
        </div>
      </label>
      <div class="preview-container mt-4" v-if="file !== null">
        <div :key="index" class="preview-card">
          <div>
            <img class="preview-img" :src="generateThumbnail(file)" />
            <p :title="file.name">{{ file.name }}</p>
          </div>
          <div>
            <button
              class="delete-button"
              @click="remove"
              title="Remove file"
            >
              <b>&times;</b>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";

const isDragging = ref(false);
const index = ref(0);
const file = ref(null);

const props = defineProps({
  index: Number,
});

const emit = defineEmits(["change"]);

onMounted(() => {
  index.value = props.index;
});

const onChange = (e) => {
  file.value = e.target.files[0];
  emit("change", file.value, index.value);
};

const generateThumbnail = (file) => {
  let fileSrc = URL.createObjectURL(file);
  setTimeout(() => {
    URL.revokeObjectURL(fileSrc);
  }, 1000);
  return fileSrc;
};

const remove = () => {
  file.value = null;
  emit("change", file.value, index.value);
};

const dragover = (e) => {
  e.preventDefault();
  isDragging.value = true;
};

const dragleave = () => {
  isDragging.value = false;
};

const drop = (e) => {
  e.preventDefault();
  file.value = e.dataTransfer.files[0];
  isDragging.value = false;
  emit("change", file.value, index.value);
};
</script>

<style scoped>
.main {
  width: 400px;
  text-align: center;
}
.dropzone-container {
  padding: 3rem;
  border: 1px solid #343536;
}
.hidden-input {
  opacity: 0;
  overflow: hidden;
  position: absolute;
  width: 1px;
  height: 1px;
}
.file-label {
  font-size: 20px;
  display: block;
  cursor: pointer;
}
.preview-container {
  display: flex;
  margin-top: 2rem;
}
.preview-card {
  display: flex;
  border: 1px solid #a2a2a2;
  padding: 5px;
  margin-left: 5px;
}
.preview-img {
  width: 100px;
  height: 100px;
  border-radius: 5px;
  border: 1px solid #a2a2a2;
}
.delete-button {
  width: 20px;
  height: 20px;
  border-radius: 50%;
}

@media screen and (max-width: 768px) {
  .main {
    width: auto;
    text-align: center;
    margin-right: 20px;
  }
}
</style>
