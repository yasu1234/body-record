<template>
  <FloatLabel>
    <Textarea
      v-model="memo"
      rows="10"
      class="record-memo p-2.5"
      @change="memoChange"
    />
    <label>メモ</label>
  </FloatLabel>
  <div class="mt-2 text-right">
    <p v-if="memo.length > 400" class="text-red-500">
      400文字以上入力しています
    </p>
    <p v-else>残り{{ 400 - memo.length }}文字入力できます</p>
  </div>
</template>

<script setup>
import { ref, watch } from "vue";
import Textarea from "primevue/textarea";
import FloatLabel from "primevue/floatlabel";

const memo = ref("");

const props = defineProps(["memo"]);

watch(props, () => {
  memo.value = props.memo;
});

const emit = defineEmits(["memo-edit"]);

const memoChange = () => {
  emit("memo-edit", memo.value);
};
</script>

<style scoped>
.record-memo {
  width: 100%;
}
</style>
