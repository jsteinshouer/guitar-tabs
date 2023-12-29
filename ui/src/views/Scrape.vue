<template>
    <div class="container">
        <p>This will check the Genius API for song matches to your tab titles. Do you want to continue?</p>
        <div class="grid">
            <div><button :aria-busy="busy" :disabled="busy" @click.prevent="scrapeMetadata">Continue</button></div>
            <div><button :disabled="busy" class="secondary" @click.prevent="$router.go(-1)">Cancel</button></div>
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue'
import store from '../store'
import { useRouter } from 'vue-router'
const router = useRouter()
const busy = ref(false)

async function scrapeMetadata() {
    busy.value = true
    await store.scrapeMetadata()
    router.push({ path: "/" })
}
</script>

<style scoped>
div.container {
    margin-top: 200px !important;
}
</style>