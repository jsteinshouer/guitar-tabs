<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import Nav from './components/Nav.vue'

const route = useRoute()

// The playing surface owns the whole window: it carries its own way back, and
// the app's chrome would only compete with the grid.
const bare = computed( () => route.path.startsWith( '/tab/' ) )
</script>

<template>
<div class="app">
    <Nav v-if="!bare" />
    <main>
        <router-view :key="$route.fullPath"></router-view>
    </main>
</div>
</template>
