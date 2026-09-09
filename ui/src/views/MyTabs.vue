<script setup>
import { computed } from 'vue'
import store from '../store'
import TabList from '../components/TabList.vue'

const query = computed( () => store.state.searchQuery.trim().toLowerCase() )

const filtered = computed( () => {
    if ( !query.value ) return store.state.myTabs
    // Lowercase both sides: matching used to fail on any capitalised search.
    return store.state.myTabs.filter( ( item ) =>
        String( item.title ).toLowerCase().includes( query.value )
        || String( item.artist || '' ).toLowerCase().includes( query.value )
        || String( item.album || '' ).toLowerCase().includes( query.value )
    )
} )

function clearSearch() {
    store.state.searchQuery = ''
}
</script>

<template>
<div class="page">
    <div class="page-head">
        <h1>Library</h1>
        <span class="count" v-if="query">{{ filtered.length }} of {{ store.state.myTabs.length }}</span>
        <span class="count" v-else-if="store.state.myTabs.length">{{ store.state.myTabs.length }} tabs</span>
    </div>

    <label class="find" v-if="store.state.myTabs.length">
        <span class="sr">Search your library</span>
        <input type="search" placeholder="search titles, artists, albums" v-model="store.state.searchQuery">
    </label>

    <p class="filter" v-if="query">
        matching <span class="term">{{ store.state.searchQuery.trim() }}</span>
        <button class="legend" @click="clearSearch">[ CLEAR ]</button>
    </p>

    <TabList :tabs="filtered" v-if="filtered.length" />

    <div class="blank" v-else-if="query">
        <h2>Nothing matches that</h2>
        <p class="prose">
            No tab in your library has &ldquo;{{ store.state.searchQuery.trim() }}&rdquo; in its title, artist, or album.
        </p>
        <button class="legend" @click="clearSearch">[ CLEAR SEARCH ]</button>
    </div>

    <div class="blank" v-else>
        <h2>Your library is empty</h2>
        <p class="prose">
            Paste a tab in and it is yours to play from — fitted to the screen, scrolling
            at whatever speed you set, with your hands free.
        </p>
        <router-link to="/new" class="legend">[ ADD THE FIRST TAB ]</router-link>
    </div>
</div>
</template>

<style scoped>
.find { display: block; margin-bottom: 0.9rem; }
.find input { width: 100%; }

.sr {
    position: absolute;
    width: 1px; height: 1px;
    overflow: hidden;
    clip: rect(0 0 0 0);
    white-space: nowrap;
}

.filter {
    font-size: 0.8125rem;
    color: var(--tf-faint);
    margin-bottom: 0.4rem;
}

.term { color: var(--tf-ink); }
.filter .legend { font-size: 0.8125rem; padding: 0.35rem 0.4rem; }

.blank { padding: 2.5rem 0 0; }
.blank h2 { margin-bottom: 0.5rem; }
.blank .legend { padding-left: 0; margin-top: 0.6rem; }
</style>
