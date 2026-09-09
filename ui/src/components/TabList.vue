<script setup>
const props = defineProps( [ 'tabs' ] )

/** The listing states each tab's own grid, the way the playing surface does. */
function columns( content ) {
    let widest = 0
    for ( const line of String( content || '' ).split( '\n' ) ) {
        const len = line.replace( /\t/g, '        ' ).replace( /\s+$/, '' ).length
        if ( len > widest ) widest = len
    }
    return widest
}

function credit( item ) {
    return [ item.artist, item.album ].filter( Boolean ).join( ' · ' )
}
</script>

<template>
<ul class="listing">
    <li v-for="item in tabs" :key="item.id">
        <router-link :to="`/tab/${item.id}`" class="entry">
            <span class="name">{{ item.title }}</span>
            <span class="cols">{{ columns( item.content ) }} cols</span>
            <span class="credit" v-if="credit( item )">{{ credit( item ) }}</span>
        </router-link>
    </li>
</ul>
</template>

<style scoped>
.listing {
    list-style: none;
    margin: 0;
    padding: 0;
}

.entry {
    display: grid;
    grid-template-columns: 1fr max-content;
    align-items: baseline;
    column-gap: 1rem;
    padding: 0.5rem 0;
    min-height: var(--tf-tap);
    color: var(--tf-ink);
    transition: color 0.18s var(--tf-ease);
}

.entry:hover .name,
.entry:focus-visible .name { color: var(--tf-live); }

.name {
    font-size: 1.0625rem;
    line-height: 1.5;
}

.cols {
    font-size: 0.8125rem;
    color: var(--tf-faint);
    font-variant-numeric: tabular-nums;
    white-space: nowrap;
}

.credit {
    grid-column: 1 / -1;
    font-size: 0.8125rem;
    color: var(--tf-faint);
    line-height: 1.4;
}
</style>
