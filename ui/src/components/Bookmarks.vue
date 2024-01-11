<template>
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

<script setup>
import { ref, computed } from 'vue'
import store from '../store'

const props = defineProps( ["tab"] )

const openListDialog = ref(false);
const createlistTitle = ref('');
const isFavorite = ref(false);
let favoriteslist = store.getFavoriteslist();
const tab = props.tab
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
	return ( thisList.tabs && thisList.tabs.find( (item) => item.id == tab.id) ) ? true : false
}

async function toggleList( listID ) {
	const thisList = store.state.lists.find( (item) => item.id == listID )
	if ( isListChecked( listID ) ) {
		await store.removeListItem( listID, tab.id );
	}
	else {
        if (!thisList.tabs) {
            thisList.tabs = []
        }
		thisList.tabs.push(tab);
		await store.addListItem( listID, tab.id );
	}
}
</script>

<style scoped>

#create-list-dialog article {
	width: 80% !important;
    padding: 15px;
	min-height: 325px;
}
.bi::before, [class^=bi-]::before, [class*=" bi-"]::before {
    display: inline;
}
.bi::after, [class^=bi-]::after, [class*=" bi-"]::after {
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
@media (max-width: 992px) {
    .bi-bookmark-star{
        margin-left: 1px !important;
    }
}

.bookmark-lists ul {
    width: 300px;
}
.bi-bookmark-star, .bi-bookmark-star-fill { 
    margin-left: 15px;
}


button,  [role=button] {
    padding: 5px;
    /* margin: 1px; */
    width: 100%;
}

details summary[role=button]:not(.outline).contrast::after {
    background-image: var(--icon-chevron-button);
}


</style>