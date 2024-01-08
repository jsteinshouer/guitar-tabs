<script setup>
import { ref, onUnmounted } from 'vue'

const autoScrollOn = ref(false)
let autoScrollTimeout = null;

function toggleAutoScroll() {
  autoScrollOn.value = !autoScrollOn.value
  autoScroll()
}

onUnmounted(() => {
	clearTimeout(autoScrollTimeout)
})

function autoScroll() {
  if ( !autoScrollOn.value ) {
    clearTimeout( autoScrollTimeout )
    autoScrollTimeout = null
  }
  else {
    window.scrollBy( {
		top: 1,
		left: 0,
		behavior: "smooth",
	} )
    autoScrollTimeout = setTimeout( autoScroll, 100);
  }
}
</script>

<template>
	<button class="outline" @click="toggleAutoScroll()"><i :class="autoScrollOn ?'bi bi-caret-down-fill' : 'bi bi-caret-down' " width="16" height="16"></i></button>
</template>

<style scoped>

</style>