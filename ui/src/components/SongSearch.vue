<script setup>
import { ref } from 'vue'

const props = defineProps( { open: Boolean } )
const emit = defineEmits( [ 'close', 'songSelected' ] )

const query = ref( '' )
const results = ref( [] )
const busy = ref( false )
const picking = ref( false )
const error = ref( '' )
const searched = ref( false )

async function search() {
    if ( !query.value.trim() || busy.value ) return
    busy.value = true
    error.value = ''
    try {
        const response = await fetch( `/api/genius?searchQuery=${encodeURIComponent( query.value )}` )
        if ( !response.ok ) throw new Error( response.statusText )
        const payload = await response.json()
        results.value = ( payload.data?.response?.hits || [] ).filter( ( item ) => item.type === 'song' )
        searched.value = true
    }
    catch ( e ) {
        error.value = 'The song search failed. Check that a Genius API key is configured.'
    }
    finally {
        busy.value = false
    }
}

async function select( hit ) {
    if ( picking.value ) return
    picking.value = true
    error.value = ''
    try {
        const response = await fetch( `/api/genius/song/${hit.result.id}` )
        if ( !response.ok ) throw new Error( response.statusText )
        const payload = await response.json()
        emit( 'songSelected', payload.data )
        emit( 'close' )
    }
    catch ( e ) {
        error.value = 'That song could not be attached. Nothing was changed.'
    }
    finally {
        picking.value = false
    }
}
</script>

<template>
<div class="finder" v-if="open">
    <div class="rule" aria-hidden="true">------------------------------------------------------------------------</div>

    <div class="head">
        <h2>Find a song</h2>
        <button class="legend" @click="$emit('close')">[ CLOSE ]</button>
    </div>

    <form class="query" @submit.prevent="search">
        <input type="text" v-model="query" placeholder="title or artist" aria-label="Song title or artist" :disabled="busy">
        <button type="submit" class="legend" :class="{ working: busy }" :disabled="busy || picking">
            {{ busy ? '[ SEARCHING ]' : '[ SEARCH ]' }}
        </button>
    </form>

    <p class="alarm-text" v-if="error">{{ error }}</p>

    <ul class="hits" v-if="results.length">
        <li v-for="hit in results" :key="hit.result.id">
            <button class="hit" @click="select( hit )" :disabled="picking">
                <span class="name">{{ hit.result.full_title }}</span>
                <span class="when" v-if="hit.result.release_date_for_display">{{ hit.result.release_date_for_display }}</span>
            </button>
        </li>
    </ul>

    <p class="prose none" v-else-if="searched && !busy">
        Nothing came back for &ldquo;{{ query }}&rdquo;. A shorter search often finds more.
    </p>

    <div class="rule" aria-hidden="true">------------------------------------------------------------------------</div>
</div>
</template>

<style scoped>
.finder { margin: 0.4rem 0 1.4rem; }

.head {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin: 0.6rem 0 0.2rem;
}

.query { display: flex; align-items: center; gap: 0.75rem; }
.query input { flex: 1; min-width: 0; }

.hits { list-style: none; margin: 0.6rem 0 0.4rem; padding: 0; }

.hit {
    display: grid;
    grid-template-columns: 1fr max-content;
    align-items: baseline;
    column-gap: 1rem;
    width: 100%;
    text-align: left;
    font-family: var(--tf-grid);
    font-size: 0.9375rem;
    color: var(--tf-ink);
    background: none;
    border: 0;
    padding: 0.5rem 0;
    min-height: var(--tf-tap);
    cursor: pointer;
}

.hit:hover .name { color: var(--tf-live); }
.hit[disabled] { color: var(--tf-receded); cursor: default; }
.when { font-size: 0.8125rem; color: var(--tf-faint); white-space: nowrap; }
.none { margin: 0.8rem 0; }
.alarm-text { margin: 0.6rem 0; }
</style>
