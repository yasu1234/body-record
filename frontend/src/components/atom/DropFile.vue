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
          id="fileInput"
          class="hidden-input"
          @change="onChange"
          @click="(e) => { e.target.value = '' }"
          accept=".pdf,.jpg,.jpeg,.png"
        />
        <label for="fileInput" class="file-label">
          <div v-if="isDragging">Release to drop files here.</div>
          <div v-else>
            ファイルをドロップ、もしくは<u>こちらをクリックして</u>アップロードしてください
          </div>
        </label>
        <div class="preview-container mt-4" v-if="file !== null">
          <div :key="file.name" class="preview-card">
            <div>
              <img class="preview-img" :src="generateThumbnail(file)" />
              <p :title="file.name">{{ file.name }}</p>
            </div>
            <div>
              <button
                class="ml-2"
                type="button"
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
import { ref } from 'vue';
  
const isDragging = ref(false);
const file = ref(null);
  
const onChange = (e) => {
  file.value = e.target.files[0];
    emit('change', file.value);
};
  
const generateThumbnail = (file) => {
    let fileSrc = URL.createObjectURL(file);
    setTimeout(() => {
      URL.revokeObjectURL(fileSrc);
    }, 1000);
    return fileSrc;
};
  
const remove = () => {
  file.value = null
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
    emit('change', file.value);
};
  
const emit = defineEmits(['change']);
</script>
  
<style scoped>
.main {
  width: 400px;
    text-align: center;
}
.dropzone-container {
    padding: 3rem;
    border: 1px solid #e2e8f0;
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
    object-fit: cover;
    border-radius: 5px;
    border: 1px solid #a2a2a2;
}
</style>
