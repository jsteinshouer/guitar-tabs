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
	<div class="toolbar grid">
    	<div>
			<button @click="$router.push( `/edit/${route.params.id}` )" alt="Edit Tab" data-tooltip="Edit Tab" data-placement="bottom"><i class="bi bi-pencil-square"></i></button>
		</div>
		<div>
			<AutoScroll />
		</div>
	</div>
</template>

<style scoped>
	.toolbar {
		position: fixed;
		width: 100px;
		top: 100px;
		right: 25px;
		grid-column-gap: 1px !important;
	}
	.toolbar button {
		padding: 5px;
		margin: 1px;
		width: 80%;
	}
	grid-column-gap {

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