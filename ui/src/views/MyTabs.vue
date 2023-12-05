<script setup>
import { ref, computed } from 'vue'
import store from '../store'
const searchQuery = ref('')
const data = store.state.myTabs;

const filteredTabs = computed(() => { 
    if ( searchQuery.value.length ) {
        return data.filter( (item) => {
            return String(item.title).toLowerCase().indexOf(searchQuery.value) > -1
        })
    }
    else {
        return data;
    }
})


</script>

<template>
    <div class="container">
        <input type="text" id="search" name="search" placeholder="Search" v-model="searchQuery" />
    </div>
    <div v-for="item in filteredTabs">
       <router-link :to="`/tab/${item.id}`" class="white"> <article>{{ item.title  }}</article></router-link>
    </div>
</template>

<style scoped>
    article {
        width: 60%;
		margin-left: 20%;
		padding: 20px;
    }
</style>