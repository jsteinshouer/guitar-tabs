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
	<AutoScroll />
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
</style>