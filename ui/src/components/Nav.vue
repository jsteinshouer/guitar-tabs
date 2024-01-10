<template>
      <div class="nav">
        <nav class="container-fluid">
          <ul>
            <li class="brand">
              <router-link to="/">
                <img src="../assets/favicon.ico" class="favicon">
                <strong>Guitar Tabs</strong>
              </router-link>
            </li>
          </ul>
          <ul v-if="isLoggedin == true">
            <li>
              <input type="search" id="search" name="search" placeholder="Search" v-model="store.state.searchQuery" @keyup.enter="$router.push( '/' )"> 
            </li>
            <li>
              <router-link to="/new" alt="Add Tab" data-tooltip="Add Tab" data-placement="bottom"><i class="bi bi-plus-square"></i></router-link>
            </li>
            <li>
              <details role="list" dir="rtl">
                <summary aria-haspopup="listbox" role="link" class="contrast"><i class="bi bi-bookmark-star"></i></summary>
                <ul role="listbox">
                  <li v-for="list in store.state.lists"> 
                    <router-link :to="`/list/${list.id}`">{{ list.title }}</router-link>
                  </li>
                </ul>
              </details>
            </li>
            <li>
              <details role="list" dir="rtl">
                <summary aria-haspopup="listbox" role="link" class="contrast"><i class="bi bi-gear"></i></summary>
                <ul role="listbox">
                  <li> 
                    <router-link to="/scrape">Scrape Data</router-link>
                  </li>
                  <li> 
                    <a href="#" @click.prevent="logout">Logout</a>
                  </li>
                </ul>
              </details>
            </li>
            <li></li>
          </ul>
        </nav>
      </div>
</template>

<script setup>
import { useRouter, useRoute } from 'vue-router'
import { computed } from 'vue'
import store from '../store';
const route = useRoute();
const router = useRouter();
const isLoggedin = computed(() => { 
    return store.isLoggedIn()
})

const logout = async function() {
  await store.logout();
  router.push({ path: "/login" })
}

</script>

<style>
.favicon {
    margin-right: 10px;
    height: 25px;
}
nav ul li {
  padding-right: 20px;
}
a {
  font-size: 1.3em;
}

#search {
  height: 2.2rem;
}
</style>