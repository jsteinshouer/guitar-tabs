<template>
<dialog :open="dialogOpen">
  <article>
    <header>
      <a href="#close" aria-label="Close" class="close" @click.prevent="$emit('close')"></a>
      <h3>Find Song</h3>
    </header>
    <div class="content" v-if="!loading">
      <input type="text" name="searchQuery" v-model="searchQuery" />
      <button @click="search" :aria-busy="busy" :disabled="busy">Search</button>
      <div class="results">
        <div v-for="hit in results">
          <article @click.once="selectSong(hit)" class="result">
            <div class="grid">
              <div><img :src="hit.result.header_image_thumbnail_url" alt="" class="thumb"></div>
              <div>
                <h5>{{ hit.result.full_title }}</h5>
                <p>Released: {{ hit.result.release_date_for_display }}</p>
                <a :href="hit.result.url" target="_blank">Lyrics</a>
              </div>
            </div>
          </article>
        </div>
      </div>
    </div>
    <div class="content" v-else aria-busy="true">Please wait…</div>
  </article>
</dialog>
</template>

<script setup>
import { ref, defineProps, defineEmits } from 'vue'

const props = defineProps({
  'dialog-open': Boolean
})

const emit = defineEmits(['close','songSelected'])

const searchQuery = ref('')
const results = ref([])
const busy = ref(false)
const loading = ref(false)

async function search() {
  busy.value = true;
  const response = await fetch( `/api/genius?searchQuery=${searchQuery.value}` );
  const apiResponse = await response.json();
  results.value = apiResponse.data.response.hits.filter( (item) => item.type == 'song' );
  busy.value = false;
}

async function selectSong(hit) {
  loading.value = true
  results.value = []

  const response = await fetch( `/api/genius/song/${hit.result.id}` );
  const apiResponse = await response.json()
  const song = apiResponse.data;

  emit( 'songSelected', song )
  emit('close')
  loading.value = false
}


</script>

<style scoped>
@media (min-width: 540px) {
  article .grid {
    grid-column-gap: 5%;
    grid-template-columns: 25% auto;
  }
}

div.content {
  margin-top: 10px;
  min-width: 600px;
}
dialog article {
    padding: 15px;
}

article.result:hover {
  cursor: pointer;
  background-color: #393939;
}
img.thumb {
  width: 100%
}

</style>