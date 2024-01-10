<script setup>
import { ref } from 'vue'
import { useRoute } from 'vue-router'
import store from '../store'
import AutoScroll from '../components/AutoScroll.vue';
const route = useRoute()

let tab = store.state.myTabs.find( (item) => item.id == route.params.id );
store.state.currentTabID = tab.id;
const isFavorite = ref(false);
let favoriteslist = store.getFavoriteslist();
isFavorite.value = favoriteslist.tabs.find( (item) => item.id == tab.id)

async function toggleFavorite() {
	if ( isFavorite.value ) {
		await store.removeListItem( favoriteslist.id, tab.id );
	}
	else {
		favoriteslist.tabs.push(tab);
		await store.addListItem( favoriteslist.id, tab.id );
	}

	isFavorite.value = !isFavorite.value;
}

</script>

<template>
    <h2>{{ tab.title }}</h2>
    <pre>{{ tab.content }}</pre>
	<div class="toolbar grid">
		<div>
			<AutoScroll />
		</div>
    	<div>
			<button @click="$router.push( `/edit/${route.params.id}` )" alt="Edit Tab" data-tooltip="Edit Tab" data-placement="bottom"><i class="bi bi-pencil-square"></i></button>
		</div>
		<div>
			<details role="list" dir="rtl" class="bookmark-lists">
				<summary aria-haspopup="listbox" role="button" class="contrast"><i :class="isFavorite ? 'bi bi-bookmark-star-fill' : 'bi bi-bookmark-star'"></i></summary>
				<ul role="listbox">
					<li class="favorites"> 
					<a href="#" @click="toggleFavorite"><i :class="isFavorite ? 'bi bi-star-fill' : 'bi bi-star'"></i> Favorites</a>
					</li>
					<li class="create"> 
					<a href="#"><i class="bi bi-plus-lg"></i> Create</a>
					</li>
				</ul>
			</details>
		</div>
	</div>

</template>

<style scoped>
	.bi::before, [class^=bi-]::before, [class*=" bi-"]::before {
		display: inline;
	}
	li.create {
		border-top-width: 1px;
		border-top-color: whitesmoke;
		border-top-style: solid;
		margin-top: 5px;
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
			width: 60px;
		}
		.bi-bookmark-star{
			margin-left: 1px !important;
		}
    }
	.toolbar button,  [role=button] {
		padding: 5px;
		/* margin: 1px; */
		width: 100%;
	}

	.bookmark-lists ul {
		width: 200px;
	}
	.bi-bookmark-star{
		margin-left: 15px;
	}

details summary[role=button]:not(.outline).contrast::after {
    background-image: var(--icon-chevron-button);
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