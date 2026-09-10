<script setup>
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import store from '../store'
import TabList from '../components/TabList.vue'

const route = useRoute()
const router = useRouter()

const list = computed( () => store.state.lists.find( ( item ) => item.id == route.params.id ) )

const tabs = computed( () => {
    if ( !list.value ) return []
    return store.state.myTabs.filter( ( item ) => list.value.tabs.find( ( t ) => t.id == item.id ) )
} )

const confirming = ref( false )
const busy = ref( false )
const error = ref( '' )

async function deleteList() {
    busy.value = true
    error.value = ''
    try {
        await store.deleteList( list.value.id )
        router.push( '/' )
    }
    catch ( e ) {
        error.value = 'That list could not be deleted. Nothing was changed.'
        confirming.value = false
    }
    finally {
        busy.value = false
    }
}
</script>

<template>
<div class="page" v-if="list">
    <div class="page-head">
        <h1>{{ list.title }}</h1>
        <span class="count">{{ tabs.length }} {{ tabs.length === 1 ? 'tab' : 'tabs' }}</span>
    </div>

    <TabList :tabs="tabs" v-if="tabs.length" />

    <div class="blank" v-else>
        <h2>Nothing filed here yet</h2>
        <p class="prose">
            Open a tab and use <span class="typed">[ LISTS ]</span> to add it to
            {{ list.title }}.
        </p>
    </div>

    <p class="alarm-text" v-if="error">{{ error }}</p>

    <div class="foot" v-if="list.title !== 'Favorites'">
        <div class="rule" aria-hidden="true">------------------------------------------------------------------------</div>
        <template v-if="!confirming">
            <button class="legend alarm" @click="confirming = true">[ DELETE LIST ]</button>
        </template>
        <template v-else>
            <p class="prose confirm">
                Delete <span class="typed">{{ list.title }}</span>? The tabs in it stay in your library.
            </p>
            <div class="legend-row">
                <button class="legend" @click="confirming = false" :disabled="busy">[ KEEP IT ]</button>
                <button class="legend destroy" :class="{ working: busy }" @click="deleteList" :disabled="busy">
                    {{ busy ? '[ DELETING ]' : '[ DELETE ]' }}
                </button>
            </div>
        </template>
    </div>
</div>

<div class="page" v-else>
    <h1>No such list</h1>
    <p class="prose">
        This list has been deleted, or the link came from an account that is not signed in
        here. Nothing was lost from your library.
    </p>
    <router-link to="/" class="legend back">[ &lt;- LIBRARY ]</router-link>
</div>
</template>

<style scoped>
.blank { padding: 2rem 0 0; }
.blank h2 { margin-bottom: 0.5rem; }
.typed { color: var(--tf-ink); }
.foot { margin-top: 2.5rem; }
.foot .legend { padding-left: 0; }
.confirm { margin: 0.8rem 0 0.2rem; }
.back { padding-left: 0; margin-top: 0.8rem; }
.alarm-text { margin-top: 1rem; }
</style>
