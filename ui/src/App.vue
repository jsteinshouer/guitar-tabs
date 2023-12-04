<script setup>
import Nav from './components/Nav.vue'
import HelloWorld from './components/HelloWorld.vue'
</script>

<template>
<div>
    <Nav />
    <main class="container-fluid">
      <router-view></router-view>
    </main>
  </div>
</template>

<style scoped>

</style>
