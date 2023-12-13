<script setup>
import { ref } from 'vue'
import { useRoute } from 'vue-router'
import store from '../store'
import SongSearch from '../components/SongSearch.vue'
const route = useRoute()
const busy = ref(false)
const openSearch = ref(false)
const tab = ref({
    id: 0,
    title: "",
    content: "",
    songTitle: "",
    songThumbnail: "",
    artist: "",
    album: "",
    geniusMetadata: {}
})

const selectedSong = ref({
    title: "",
    thumbnail: "",
    artist: "",
    album: "",
    geniusMetadata: {}
})

if ( route.params.id ) {
    tab.value = store.state.myTabs.find( (item) => item.id == route.params.id )
    selectedSong.value.title = tab.value.songTitle
    selectedSong.value.thumbnail = tab.value.songThumbnail
    selectedSong.value.album = tab.value.album
    selectedSong.value.artist = tab.value.artist
    selectedSong.value.geniusMetadata = tab.value.geniusMetadata
}


async function saveTab() {
    busy.value = true;
    tab.value.songTitle = selectedSong.value.title
    tab.value.songThumbnail = selectedSong.value.thumbnail
    tab.value.album = selectedSong.value.album
    tab.value.artist = selectedSong.value.artist
    tab.value.geniusMetadata = selectedSong.value.geniusMetadata
    if ( tab.value.id == 0 ) {
        await store.addTab( tab.value );
    }
    else {
        await store.updateTab( tab.value );
    }
    busy.value = false;
}

async function selectSong(song) {
    selectedSong.value.title = song.title
    selectedSong.value.thumbnail = song.thumbnail
    selectedSong.value.album = song.album
    selectedSong.value.artist = song.artist
    selectedSong.value.geniusMetadata = song.geniusMetadata
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
        Song  <a @click.prevent="openSearch = true" style="float: inline-end;">Find Song</a>
        <label for="song">
            <!-- <input type="text" id="song" v-model="tab.songTitle"> -->
            <article class="result" v-if="selectedSong.title != ''">
            <div class="grid">
              <div><img :src="selectedSong.thumbnail" alt="" class="thumb"></div>
              <div>
                <h5>{{ selectedSong.title }}</h5>
                <table>
                    <tbody>
                        <tr>
                            <th>Album</th>
                            <td>{{ selectedSong.album }}</td>
                        </tr>
                        <tr>
                            <th>Artist</th>
                            <td>{{ selectedSong.artist }}</td>
                        </tr>
                    </tbody>
                </table>
                <!-- <a :href="hit.result.url" target="_blank">Lyrics</a> -->
              </div>
            </div>
          </article>
          <article class="result" v-else><p>No song selected</p></article>
        </label>
        <button @click.prevent="saveTab" :aria-busy="busy" :disabled="busy">Save</button>
    </div>
    <SongSearch :dialog-open="openSearch" @close="openSearch = false" @songSelected="selectSong" />
</template>

<style scoped>
.form {
    width: 60%;
    margin-left: 20%;
}
@media (min-width: 540px) {
    article.result .grid {
        grid-column-gap: 5%;
        grid-template-columns: 25% auto;
    }
}
article {
    margin: 0px;
    margin-bottom: 20px;
    margin-top: 5px;
    padding: 15px;
}
</style>