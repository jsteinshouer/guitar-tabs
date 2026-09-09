<script setup>
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import store from '../store'
import SongSearch from '../components/SongSearch.vue'

const route = useRoute()
const router = useRouter()

const editing = computed( () => !!route.params.id )
const existing = editing.value
    ? store.state.myTabs.find( ( item ) => item.id == route.params.id )
    : null

const tab = ref( existing
    ? { ...existing }
    : { id: 0, title: '', content: '', songTitle: '', songThumbnail: '', artist: '', album: '', geniusMetadata: {} } )

const song = ref( {
    title: existing?.songTitle || '',
    thumbnail: existing?.songThumbnail || '',
    artist: existing?.artist || '',
    album: existing?.album || '',
    geniusMetadata: existing?.geniusMetadata || {}
} )

const finding = ref( false )
const confirming = ref( false )
const busy = ref( false )
const error = ref( '' )
const saved = ref( false )

const columns = computed( () => {
    let widest = 0
    for ( const line of String( tab.value.content || '' ).split( '\n' ) ) {
        const len = line.replace( /\t/g, '        ' ).replace( /\s+$/, '' ).length
        if ( len > widest ) widest = len
    }
    return widest
} )

const lines = computed( () => String( tab.value.content || '' ).split( '\n' ).length )

async function save() {
    if ( busy.value ) return
    if ( !tab.value.title.trim() ) {
        error.value = 'A title is needed — it is how you will find this tab again.'
        return
    }

    busy.value = true
    error.value = ''
    saved.value = false

    tab.value.songTitle = song.value.title
    tab.value.songThumbnail = song.value.thumbnail
    tab.value.album = song.value.album
    tab.value.artist = song.value.artist
    tab.value.geniusMetadata = song.value.geniusMetadata

    try {
        if ( !tab.value.id ) {
            await store.addTab( tab.value )
            // Land on the tab just written: the confirmation is arriving at it.
            const created = store.state.myTabs.find( ( item ) => item.title === tab.value.title )
            if ( created ) return router.push( `/tab/${created.id}` )
            router.push( '/' )
        }
        else {
            await store.updateTab( tab.value )
            await store.loadTabs()
            router.push( `/tab/${tab.value.id}` )
        }
    }
    catch ( e ) {
        error.value = 'That could not be saved, so nothing was changed. Try again.'
    }
    finally {
        busy.value = false
    }
}

function selectSong( picked ) {
    song.value = {
        title: picked.title,
        thumbnail: picked.thumbnail,
        artist: picked.artist,
        album: picked.album,
        geniusMetadata: picked.geniusMetadata
    }
}

function clearSong() {
    song.value = { title: '', thumbnail: '', artist: '', album: '', geniusMetadata: {} }
}

async function remove() {
    busy.value = true
    error.value = ''
    try {
        await store.deleteTab( tab.value )
        router.push( '/' )
    }
    catch ( e ) {
        error.value = 'That could not be deleted, so nothing was changed.'
        confirming.value = false
    }
    finally {
        busy.value = false
    }
}
</script>

<template>
<div class="page">
    <div class="legend-row">
        <router-link :to="editing ? `/tab/${route.params.id}` : '/'" class="legend">[ &lt;- BACK ]</router-link>
    </div>

    <h1>{{ editing ? 'Edit tab' : 'New tab' }}</h1>

    <label class="field">
        <span class="label">title</span>
        <input type="text" v-model="tab.title" placeholder="the song as you will look for it" :disabled="busy">
    </label>

    <label class="field">
        <span class="label">
            content
            <span class="grid-state" v-if="tab.content">&middot; {{ columns }} cols &middot; {{ lines }} lines</span>
        </span>
        <textarea v-model="tab.content" rows="16" spellcheck="false" placeholder="paste the tab here" :disabled="busy"></textarea>
        <span class="hint">Spacing is preserved exactly as you paste it.</span>
    </label>

    <div class="field">
        <span class="label">song</span>
        <div class="song" v-if="song.title">
            <span class="name">{{ song.title }}</span>
            <span class="credit" v-if="song.artist || song.album">{{ [ song.artist, song.album ].filter( Boolean ).join( ' · ' ) }}</span>
            <div class="legend-row">
                <button class="legend" @click="finding = !finding">[ CHANGE ]</button>
                <button class="legend" @click="clearSong">[ REMOVE ]</button>
            </div>
        </div>
        <div class="song" v-else>
            <span class="credit">No song attached — artist, album, and a lyrics link come from one.</span>
            <div class="legend-row">
                <button class="legend" @click="finding = !finding">[ FIND SONG ]</button>
            </div>
        </div>
    </div>

    <SongSearch :open="finding" @close="finding = false" @songSelected="selectSong" />

    <p class="alarm-text" v-if="error">{{ error }}</p>

    <div class="rule" aria-hidden="true">------------------------------------------------------------------------</div>

    <div class="legend-row actions" v-if="!confirming">
        <button class="legend primary" :class="{ working: busy }" @click="save" :disabled="busy">
            {{ busy ? '[ SAVING ]' : '[ SAVE ]' }}
        </button>
        <button class="legend alarm" v-if="editing" @click="confirming = true" :disabled="busy">[ DELETE ]</button>
    </div>

    <div class="actions" v-else>
        <p class="prose confirm">
            Delete <span class="typed">{{ tab.title }}</span>? This cannot be undone.
        </p>
        <div class="legend-row">
            <button class="legend" @click="confirming = false" :disabled="busy">[ KEEP IT ]</button>
            <button class="legend destroy" :class="{ working: busy }" @click="remove" :disabled="busy">
                {{ busy ? '[ DELETING ]' : '[ DELETE ]' }}
            </button>
        </div>
    </div>
</div>
</template>

<style scoped>
h1 { margin-bottom: 1.4rem; }

.grid-state { color: var(--tf-faint); }

.hint {
    display: block;
    font-size: 0.8125rem;
    color: var(--tf-faint);
    margin-top: 0.3rem;
}

textarea {
    font-size: 0.875rem;
    line-height: 1.35;
    white-space: pre;
    overflow-x: auto;
    tab-size: 8;
}

.song { padding: 0.2rem 0 0; }
.song .name { display: block; font-size: 1.0625rem; }
.song .credit { display: block; font-size: 0.8125rem; color: var(--tf-faint); }
.song .legend-row .legend:first-child { padding-left: 0; }

.actions { margin-top: 0.4rem; }
.actions .legend:first-child { padding-left: 0; }
.confirm { margin: 0.9rem 0 0.2rem; }
.typed { color: var(--tf-ink); }
.alarm-text { margin: 1rem 0; }
</style>
