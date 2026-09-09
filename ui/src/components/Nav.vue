<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import store from '../store'

const router = useRouter()
const listsOpen = ref( false )
const menuOpen = ref( false )

const isLoggedIn = computed( () => store.isLoggedIn() )

async function logout() {
    menuOpen.value = false
    await store.logout()
    router.push( { path: '/login' } )
}
</script>

<template>
<header class="nav">
    <div class="bar">
        <router-link to="/" class="legend brand">
            <span class="full">GUITAR TABS</span><span class="short">TABS</span>
        </router-link>

        <template v-if="isLoggedIn">
            <router-link to="/new" class="legend">[ NEW ]</router-link>

            <div class="menu">
                <button class="legend" :aria-expanded="listsOpen" @click="listsOpen = !listsOpen; menuOpen = false">[ LISTS ]</button>
                <div class="panel" v-if="listsOpen">
                    <div class="rule" aria-hidden="true">------------------------------------------------------------</div>
                    <router-link
                        v-for="list in store.state.lists"
                        :key="list.id"
                        :to="`/list/${list.id}`"
                        class="row"
                        @click="listsOpen = false"
                    ><span class="box">[&gt;]</span>{{ list.title }}</router-link>
                    <p class="row empty" v-if="!store.state.lists.length"><span class="box">[ ]</span>no lists yet</p>
                    <div class="rule" aria-hidden="true">------------------------------------------------------------</div>
                </div>
            </div>

            <div class="menu">
                <button class="legend" :aria-expanded="menuOpen" @click="menuOpen = !menuOpen; listsOpen = false">[ MORE ]</button>
                <div class="panel" v-if="menuOpen">
                    <div class="rule" aria-hidden="true">------------------------------------------------------------</div>
                    <router-link to="/scrape" class="row" @click="menuOpen = false"><span class="box">[&gt;]</span>find song data</router-link>
                    <button class="row" @click="logout"><span class="box">[&gt;]</span>sign out</button>
                    <div class="rule" aria-hidden="true">------------------------------------------------------------</div>
                </div>
            </div>
        </template>
    </div>
    <div class="seam"></div>
</header>
</template>

<style scoped>
.nav {
    position: sticky;
    top: 0;
    z-index: 50;
    background: var(--tf-ground);
}

.bar {
    display: flex;
    align-items: center;
    gap: 0.15rem;
    padding: 0 var(--tf-gutter);
}

.short { display: none; }

.brand {
    font-weight: 700;
    color: var(--tf-ink);
    letter-spacing: 0.02em;
    padding-left: 0;
    margin-right: auto;
}

.menu { position: relative; }

.panel {
    position: absolute;
    top: 100%;
    right: 0;
    z-index: 30;
    width: 15rem;
    max-width: calc(100vw - 1.5rem);
    background: var(--tf-ground);
}

.row {
    display: block;
    width: 100%;
    text-align: left;
    font-family: var(--tf-grid);
    font-size: 0.875rem;
    color: var(--tf-ink);
    background: none;
    border: 0;
    padding: 0.55rem 0.75rem;
    min-height: var(--tf-tap);
    line-height: 1.9;
    cursor: pointer;
}

.row:hover { color: var(--tf-live); }
.row.empty { color: var(--tf-faint); cursor: default; }

/* The same fixed box column the playing surface uses, so every label in
   either lists panel starts on one advance. */
.box {
    display: inline-block;
    width: 2.5em;
    color: var(--tf-legend);
}

@media (max-width: 520px) {
    .bar { gap: 0; }
    .full { display: none; }
    .short { display: inline; }
}
</style>
