<template>
      <div class="nav">
        <nav class="container-fluid">
          <ul>
            <li class="brand">
              <router-link to="/">
                <img src="favicon.ico" class="favicon">
                <strong>Guitar Tabs</strong>
              </router-link>
            </li>
          </ul>
          <ul v-if="isLoggedin == true">
            <li v-if="route.params.id">
              <router-link :to="`/edit/${route.params.id}`">Edit</router-link>
            </li>
            <li>
              <router-link to="/new">New</router-link>
            </li>
            <!-- <li>
              <details role="list" dir="rtl">
                <summary aria-haspopup="listbox" role="link" class="contrast">Theme</summary>
                <ul role="listbox">
                  <li><a href="#" data-theme-switcher="auto">Auto</a></li>
                  <li><a href="#" data-theme-switcher="light">Light</a></li>
                  <li><a href="#" data-theme-switcher="dark">Dark</a></li>
                </ul>
              </details>
            </li> -->
            <li></li>
          </ul>
        </nav>
      </div>
</template>

<script setup>
import { useRoute } from 'vue-router'
import { computed } from 'vue'
import store from '../store';
const route = useRoute();
const isLoggedin = computed(() => { 
    return store.isLoggedIn()
})

</script>

<style>
.favicon {
    margin-right: 10px;
    height: 25px;
}
nav ul li {
  padding-right: 20px;
}
</style>