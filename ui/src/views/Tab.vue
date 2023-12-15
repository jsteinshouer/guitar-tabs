<script setup>
import { ref } from 'vue'
import { useRoute } from 'vue-router'
import store from '../store'
const route = useRoute()

let tab = store.state.myTabs.find( (item) => item.id == route.params.id );
store.state.currentTabID = tab.id;

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
    <h2>{{ tab.title }}</h2>
    <pre>{{ tab.content }}</pre>
	<div class="toolbar">
		<button class="outline" @click="toggleAutoScroll()"><i :class="autoScrollOn ?'bi bi-caret-down-fill' : 'bi bi-caret-down' " width="16" height="16"></i></button>
	</div>
</template>

<style scoped>
	pre {
        padding: 8px;
		font-family: monospace;
		font-size: 1.1em;
		line-height: normal;
		letter-spacing: normal;
        text-align: start;
		border-color: white;
		border: solid .5px;
	}

	.toolbar {
		position: fixed;
		bottom: 30px;
		right: 30px;
	}
</style>