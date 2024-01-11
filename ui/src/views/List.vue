<script setup>
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import store from '../store'
import TabList from '../components/TabList.vue';

const route = useRoute()
const router = useRouter()
const data = store.state.myTabs;
const list = store.state.lists.find( (item) => item.id == route.params.id );
const deleteConfirm = ref(false);
const listTitle = ref(list.title)
const listTabs = ref([]);

listTabs.value = store.state.myTabs.filter( (item) => list.tabs.find( tab => tab.id == item.id) )

async function deleteList() {
    await store.deleteList( list.id )
    router.push( "/" )
}

</script>

<template>
    <div class="center">
        <h2>{{ listTitle }}</h2>
    </div>
    <TabList :tabs="listTabs" />
    <div class="center toolbar" v-if="list.title != 'Favorites'">
        <button class="delete" @click="deleteConfirm = true">Delete List</button>
    </div>
    <dialog :open="deleteConfirm">
    <article>
        <h3>Are you sure?</h3>
        <p>Please confirm you would like to delete the list.</p>
        <footer>
        <a href="#cancel" role="button" class="secondary" @click="deleteConfirm = false">Cancel</a>
        <a href="#confirm" role="button" @click="deleteList">Confirm</a>
        </footer>
    </article>
    </dialog>

</template>

<style scoped>
    .center {
        text-align: center !important;
    }

    .toolbar {
        margin-top: 30px;
        display: inherit;
        width: 20% ;
        margin-left: 40%;
    }

    dialog article {
        width: 40% !important;
        padding: 15px;
        min-height: 290px;
    }

</style>