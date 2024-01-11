<script setup>
const props = defineProps(["tabs"]);
</script>

<template>
    <div class="myTabs">
        <div v-for="item in tabs">
            <router-link :to="`/tab/${item.id}`" class="white card"> <article>
            <div class="grid">
              <div>
                <img :src="item.songThumbnail" alt="" class="thumb" v-if="item.songThumbnail">
                <!-- <img :src="MusicIcon" alt="" class="icon" v-else> -->
                <i class="bi bi-music-note-list" style="font-size: 2rem; color: white;" v-else></i>
                </div>
              <div>
                <h5>{{ item.title }}</h5>
                <p v-if="item.album">{{ item.album }} ~ {{ item.artist }}</p>
                <!-- <a :href="hit.result.url" target="_blank">Lyrics</a> -->
              </div>
            </div>    
            </article></router-link>
        </div>
    </div>
</template>

<style scoped>
.myTabs {
    width: 60%;
    margin-left: 20%;
}

.myTabs article {
    padding: 20px;
}

@media (min-width: 540px) {
article .grid {
    grid-column-gap: 2%;
    grid-template-columns: 25% auto;
  }
}
dialog article {
    padding: 10px;
}

article:hover {
  cursor: pointer;
  background-color: #393939;
}

.card {
    text-decoration: none;
}
img.thumb {
  width: 100%;
}

img.icon {
  width: 100%;
  max-width: 75px;
  color: white;
}

</style>