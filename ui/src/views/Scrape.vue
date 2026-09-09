<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import store from '../store'

const router = useRouter()
const busy = ref( false )
const error = ref( '' )

async function run() {
    busy.value = true
    error.value = ''
    try {
        await store.scrapeMetadata()
        router.push( { path: '/' } )
    }
    catch ( e ) {
        error.value = 'The song lookup failed. Your tabs are unchanged — check that a Genius API key is configured.'
    }
    finally {
        busy.value = false
    }
}
</script>

<template>
<div class="page">
    <h1>Find song data</h1>
    <p class="prose">
        This checks the Genius catalogue for songs matching your tab titles, and fills in
        artist, album, and a lyrics link where it finds a confident match. It only adds
        information — your tab content is never touched.
    </p>

    <p class="alarm-text" v-if="error">{{ error }}</p>

    <div class="legend-row">
        <button class="legend primary" :class="{ working: busy }" @click="run" :disabled="busy">
            {{ busy ? '[ LOOKING ]' : '[ RUN IT ]' }}
        </button>
        <button class="legend" @click="$router.push('/')" :disabled="busy">[ NOT NOW ]</button>
    </div>
</div>
</template>

<style scoped>
.prose { margin: 0.6rem 0 1.4rem; }
.alarm-text { margin-bottom: 1rem; }
</style>
