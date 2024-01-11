<script setup>
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'
import store from '../store'
import AutoScroll from '../components/AutoScroll.vue';
import Bookmarks from '../components/Bookmarks.vue';
const route = useRoute()
let tab = store.state.myTabs.find( (item) => item.id == route.params.id );
store.state.currentTabID = tab.id;


</script>

<template>
	<div class="container-fluid">
    <h2>{{ tab.title }}</h2>
	<div class="toolbar grid">
		<div>
			<AutoScroll />
		</div>
    	<div>
			<button @click="$router.push( `/edit/${route.params.id}` )" alt="Edit Tab" data-tooltip="Edit Tab" data-placement="bottom"><i class="bi bi-pencil-square"></i></button>
		</div>
		<div>
			<Bookmarks :tab="tab" />
		</div>
	</div>
    <pre>{{ tab.content }}</pre>
</div>
</template>

<style scoped>
.bi::before, [class^=bi-]::before, [class*=" bi-"]::before {
    display: inline;
}
.toolbar {
    position: fixed;
    width: 250px;
    top: 100px;
    right: 30px;
    grid-column-gap: 1px !important;
}

@media (max-width: 992px) {

	.toolbar {
		position: inherit;
		width: 100%;
		grid-column-gap: 5px !important;
	}

	.grid {
		display: flex;
		margin: 1px;
	}

	.grid div {
		width: 30%;
	}

	h2 {
		margin-bottom: 15px;
	}

}
.toolbar button,  [role=button] {
    padding: 5px;
    /* margin: 1px; */
    width: 100%;
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