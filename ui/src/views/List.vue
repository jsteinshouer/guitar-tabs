<script setup>
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'
import store from '../store'
import TabList from '../components/TabList.vue';

const route = useRoute()
const data = store.state.myTabs;
const list = store.state.lists.find( (item) => item.id == route.params.id );
const listTitle = ref(list.title)
const listTabs = ref([]);

listTabs.value = store.state.myTabs.filter( (item) => list.tabs.find( tab => tab.id == item.id) )

</script>

<template>
    <TabList :tabs="listTabs" />
</template>

<style scoped>

</style>