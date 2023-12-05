<script setup>
import { ref } from 'vue'
import { useRoute } from 'vue-router'
import store from '../store'
const route = useRoute()
const tab = ref({})
tab.value = store.state.myTabs.find( (item) => item.id == route.params.id )
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
        <button>Save</button>
    </div>
</template>

<style scoped>
    .form {
        width: 60%;
		margin-left: 20%;
    }
</style>