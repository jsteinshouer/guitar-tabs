<script setup>
import { ref, computed } from 'vue'
import store from '../store'
import TabList from '../components/TabList.vue';
const data = store.state.myTabs;

const filteredTabs = computed(() => { 
    if ( store.state.searchQuery.length ) {
        return data.filter( (item) => {
            return String(item.title).toLowerCase().indexOf(store.state.searchQuery) > -1
        })
    }
    else {
        return data;
    }
})
</script>

<template>
    <TabList :tabs="filteredTabs" />
</template>

<style scoped>

</style>