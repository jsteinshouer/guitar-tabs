<script setup>
import { ref } from 'vue'

const autoScrollOn = ref(false)
let autoScrollTimeout = null;

function toggleAutoScroll() {
  autoScrollOn.value = !autoScrollOn.value
  autoScroll()
}

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
	<div class="toolbar">
		<button class="outline" @click="toggleAutoScroll()"><i :class="autoScrollOn ?'bi bi-caret-down-fill' : 'bi bi-caret-down' " width="16" height="16"></i></button>
	</div>
</template>

<style scoped>
	.toolbar {
		position: fixed;
		bottom: 30px;
		right: 30px;
	}
</style>