<script setup>
import { ref } from 'vue'


let tabs = ref([]);

async function loadData() {
  const authResponse = await fetch("/api/authorize", {
    method: "POST",
    body: JSON.stringify({
      username: "slash",
      password: "itssoeasy"
    })
  });
  const authResult = await authResponse.json();

  const dataResponse = await fetch("/api/tablature");
  const dataResult = await dataResponse.json();
  tabs.value = dataResult.data;
}
loadData();


</script>

<template>
    <div v-for="item in tabs">
        <article>{{ item.title  }}</article>
    </div>
</template>