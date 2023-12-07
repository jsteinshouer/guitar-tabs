<script setup>
import { ref } from 'vue'
import { useRoute } from 'vue-router'
import store from '../store'
const route = useRoute()
const busy = ref(false)
const tab = ref({
    id: 0,
    title: "",
    content: ""
})
if ( route.params.id ) {
    tab.value = store.state.myTabs.find( (item) => item.id == route.params.id )
}


async function saveTab() {
    busy.value = true;
    if ( tab.value.id == 0 ) {
        await store.addTab( tab.value );
    }
    else {
        await store.updateTab( tab.value );
    }
    busy.value = false;
}
</script>

<template>
    <div class="form">
        Title
        <label for="title">
            <input type="text" id="title" name="title" placeholder="Title" v-model="tab.title" required>
        </label>
        <label for="content">
            Content
            <textarea name="content" placeholder="Content" rows="15" v-model="tab.content"></textarea>
        </label>
        <button @click.prevent="saveTab" :aria-busy="busy" :disabled="busy">Save</button>
    </div>
</template>

<style scoped>
    .form {
        width: 60%;
		margin-left: 20%;
    }
</style>