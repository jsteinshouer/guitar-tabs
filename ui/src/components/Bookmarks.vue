<script setup>
import { ref, computed, watch, onMounted } from 'vue'
import store from '../store'

const props = defineProps( [ 'tab' ] )

const open = ref( false )

const emit = defineEmits( [ 'open' ] )

watch( open, ( isOpen ) => emit( 'open', isOpen ) )
const newTitle = ref( '' )
const creating = ref( false )
const favorites = ref( null )
const error = ref( '' )

const lists = computed( () => store.state.lists.filter( ( item ) => item.title != 'Favorites' ) )

const isFavorite = computed( () => holds( favorites.value ) )

/** Favorites is created on demand, so it may not exist until this resolves. */
onMounted( async () => {
    try {
        favorites.value = await store.getFavoriteslist()
    }
    catch ( e ) {
        error.value = 'Lists are unavailable right now.'
    }
} )

function holds( list ) {
    return !!( list && list.tabs && list.tabs.find( ( item ) => item.id == props.tab.id ) )
}

async function toggleList( list ) {
    if ( !list ) return
    error.value = ''
    const held = holds( list )
    try {
        if ( held ) await store.removeListItem( list.id, props.tab.id )
        else await store.addListItem( list.id, props.tab.id )
        favorites.value = store.state.lists.find( ( item ) => item.id == favorites.value?.id ) || favorites.value
    }
    catch ( e ) {
        error.value = held ? 'Could not remove it from that list.' : 'Could not add it to that list.'
    }
}

async function createList() {
    const title = newTitle.value.trim()
    if ( !title || creating.value ) return
    creating.value = true
    error.value = ''
    try {
        const created = await store.createList( title )
        newTitle.value = ''
        if ( created ) await store.addListItem( created.id, props.tab.id )
    }
    catch ( e ) {
        error.value = 'Could not create that list.'
    }
    finally {
        creating.value = false
    }
}
</script>

<template>
<span class="lists">
    <button
        class="legend"
        :class="{ live: isFavorite }"
        :aria-expanded="open"
        @click="open = !open"
    >[ {{ isFavorite ? 'SAVED' : 'LISTS' }} ]</button>

    <div class="panel" v-if="open">
        <div class="rule" aria-hidden="true">------------------------------------------------------------</div>
        <button class="row" @click="toggleList( favorites )" :disabled="!favorites">
            <span class="box">{{ isFavorite ? '[x]' : '[ ]' }}</span>Favorites
        </button>
        <button class="row" v-for="list in lists" :key="list.id" @click="toggleList( list )">
            <span class="box">{{ holds( list ) ? '[x]' : '[ ]' }}</span>{{ list.title }}
        </button>

        <div class="rule" aria-hidden="true">------------------------------------------------------------</div>
        <form class="create" @submit.prevent="createList">
            <span class="box">[+]</span>
            <input
                type="text"
                v-model="newTitle"
                placeholder="new list"
                aria-label="Name a new list"
                :disabled="creating"
            >
        </form>

        <p class="error" v-if="error">{{ error }}</p>
        <div class="rule" aria-hidden="true">------------------------------------------------------------</div>
    </div>
</span>
</template>

<style scoped>
.lists { position: relative; }

.legend {
    font-family: var(--tf-grid);
    font-size: 0.9375rem;
    white-space: nowrap;
    color: var(--tf-legend);
    background: none;
    border: 0;
    padding: 0.6rem 0.5rem 0.6rem 0;
    min-height: 44px;
    cursor: pointer;
    transition: color 0.18s var(--tf-ease);
}

.legend:hover { color: var(--tf-ink); }
.legend.live { color: var(--tf-live); }
.legend:focus-visible { outline: 1px solid var(--tf-live); outline-offset: 2px; }

.panel {
    position: absolute;
    top: 100%;
    /* LISTS is the last legend in the row: open leftward so the panel
       never pushes the document wider than the screen. */
    right: 0;
    left: auto;
    z-index: 30;
    /* Fixed width: the dash rules clip to the panel, they never size it. */
    width: 16rem;
    max-width: calc(100vw - 1.5rem);
    padding: 0;
    background: var(--tf-ground);
    font-family: var(--tf-grid);
}

/* The world's own rule: a dash run, not a border. */
.rule {
    width: 100%;
    box-sizing: border-box;
    overflow: hidden;
    white-space: nowrap;
    color: var(--tf-rule);
    font-size: 0.875rem;
    line-height: 1;
    padding: 0.25rem 0.75rem;
    user-select: none;
}

.row {
    display: block;
    width: 100%;
    box-sizing: border-box;
    text-align: left;
    font-family: inherit;
    font-size: 0.875rem;
    color: var(--tf-ink);
    background: none;
    border: 0;
    padding: 0.55rem 0.75rem;
    min-height: 44px;
    cursor: pointer;
}

.row:hover { color: var(--tf-live); }
.row:focus-visible { outline: 1px solid var(--tf-live); outline-offset: -1px; }
.row[disabled] { color: var(--tf-faint); cursor: default; }

.box {
    display: inline-block;
    width: 2.5em;
    color: var(--tf-legend);
}

.create {
    display: flex;
    align-items: center;
    /* Same size as a row, so the 2.5em box resolves to the same advance
       and both labels sit in one column. */
    font-size: 0.875rem;
    padding: 0.1rem 0.75rem 0.15rem;
}

.create input {
    flex: 1;
    min-width: 0;
    font-family: inherit;
    font-size: 0.875rem;
    color: var(--tf-ink);
    caret-color: var(--tf-live);
    background: none;
    border: 0;
    padding: 0.5rem 0;
}

.create input::placeholder { color: var(--tf-faint); }
.create input:focus { outline: 0; }
.create input:focus-visible { outline: 0; }


.error {
    margin: 0.25rem 0 0;
    padding: 0 0.75rem 0.4rem;
    font-size: 0.8125rem;
    color: var(--tf-alarm);
}
</style>
