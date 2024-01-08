<script setup>
import { ref } from 'vue'
import { useRoute } from 'vue-router'
import store from '../store'
import AutoScroll from '../components/AutoScroll.vue';
const route = useRoute()

let tab = store.state.myTabs.find( (item) => item.id == route.params.id );
store.state.currentTabID = tab.id;

</script>

<template>
    <h2>{{ tab.title }}</h2>
    <pre>{{ tab.content }}</pre>
	<div class="toolbar">
    	<button @click="$router.push( `/edit/${route.params.id}` )" alt="Edit Tab" data-tooltip="Edit Tab" data-placement="bottom"><i class="bi bi-pencil-square"></i></button>
		<AutoScroll />
	</div>
</template>

<style scoped>
	.toolbar {
		position: fixed;
		width: 150px;
		top: 80px;
		right: 25px;
	}
	.toolbar button {
		display: inline;
		width: 40%;
		margin: 3px;
	}
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
</style>