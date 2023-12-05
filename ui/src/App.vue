<script setup>
import Nav from './components/Nav.vue'
</script>

<template>
<div>
    <Nav />
    <main class="container-fluid">
      <router-view :key="$route.fullPath"></router-view>
    </main>
  </div>
</template>

<style scoped>

</style>
