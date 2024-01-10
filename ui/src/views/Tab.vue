<script setup>
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'
import store from '../store'
import AutoScroll from '../components/AutoScroll.vue';
const route = useRoute()
const openListDialog = ref(false);
const createlistTitle = ref('');
let tab = store.state.myTabs.find( (item) => item.id == route.params.id );
store.state.currentTabID = tab.id;
const isFavorite = ref(false);
let favoriteslist = store.getFavoriteslist();
isFavorite.value = favoriteslist.tabs.find( (item) => item.id == tab.id)

const customLists = computed(() => { 
    return store.state.lists.filter( (item) => item.title != "Favorites") 
})

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

async function createList() {
	if ( createlistTitle.value != '' ) {
		store.createList( createlistTitle.value )
		openListDialog.value = false
	}
}

function isListChecked( listID ) {
	const thisList = store.state.lists.find( (item) => item.id == listID )
	return thisList.tabs.find( (item) => item.id == tab.id) ? true : false
}

async function toggleList( listID ) {
	const thisList = store.state.lists.find( (item) => item.id == listID )
	if ( isListChecked( listID ) ) {
		await store.removeListItem( listID, tab.id );
	}
	else {
		thisList.tabs.push(tab);
		await store.addListItem( listID, tab.id );
	}
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
					<li > 
						
						<a href="#" @click="toggleFavorite"><i :class="isFavorite ? 'bi bi-star-fill' : 'bi bi-star'"></i>Favorites</a>
					</li>
					<template v-for="list in customLists">
						<li> 
							<a href="#" @click="toggleList(list.id)"> <i :class="isListChecked(list.id) ? 'bi bi-check-square' : 'bi bi-square'" class="checkbox"></i>{{ list.title }}</a>
						</li>
					</template>
					<li class="create"> 
					<a href="#" @click="openListDialog=true"><i class="bi bi-plus-lg"></i> Create</a>
					</li>
				</ul>
			</details>
		</div>
	</div>

	<dialog :open="openListDialog" id="create-list-dialog">
		<article>
			<h3>Create a new list!</h3>
			<p>
				<input type="text" id="title" name="title" placeholder="Title" required v-model="createlistTitle">
			</p>
			<footer>
				<div class="grid">
					<div><button role="button" class="secondary" @click="openListDialog=false">Cancel</button></div>
					<div><button role="button" @click="createList">Confirm</button></div>
				</div>
			</footer>
		</article>
	</dialog>
</template>

<style scoped>

#create-list-dialog article {
	width: 80% !important;
    padding: 15px;
	min-height: 325px;
}
	.bi::before, [class^=bi-]::before, [class*=" bi-"]::before {
		display: inline;
	}
	.bookmark-lists ul li {
		text-align: left;
	}
	.bookmark-lists ul li i {
		margin-right: 15px;
	}
	.checkbox {
		float: left;
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
		width: 300px;
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