<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { useRoute } from 'vue-router'
import store from '../store'
import Transport from '../components/Transport.vue'
import Bookmarks from '../components/Bookmarks.vue'
import { useFitToGrid } from '../composables/useFitToGrid'
import { useScrollTransport } from '../composables/useScrollTransport'

const route = useRoute()

// A tab can be missing: a stale bookmark, a deleted song, a link from another device.
const tab = computed( () => store.state.myTabs.find( ( item ) => item.id == route.params.id ) )

const metadata = computed( () => {
    if ( !tab.value || !tab.value.geniusMetadata ) return {}
    try {
        return JSON.parse( tab.value.geniusMetadata )
    }
    catch ( e ) {
        return {}
    }
} )

const content = computed( () => ( tab.value && tab.value.content ) || '' )
const lines = computed( () => content.value.split( '\n' ).length )

const { host, grid, fontSize, columns, condensed, tight, scale, setScale } = useFitToGrid( content )

const lineHeightPx = () => {
    const el = grid.value
    if ( !el ) return 18
    const measured = parseFloat( getComputedStyle( el ).lineHeight )
    return Number.isFinite( measured ) ? measured : fontSize.value * 1.35
}

const transport = useScrollTransport( { lineHeight: lineHeightPx } )

/** Which line is under the reading anchor right now. */
const currentLine = ref( 1 )

/**
 * On a short viewport — the landscape the "turn the device" legend asks for —
 * the header collapses to one line so the payoff is the grid, not more chrome.
 */
const listsOpen = ref( false )
const compact = ref( false )
function measureViewport() {
    compact.value = window.innerHeight < 520
}

function trackPosition() {
    const el = grid.value
    if ( !el ) return
    if ( window.scrollY <= 0 ) {
        currentLine.value = 1
        return
    }
    const top = el.getBoundingClientRect().top
    const anchor = window.innerHeight * 0.38
    const passed = Math.round( ( anchor - top ) / lineHeightPx() )
    currentLine.value = Math.min( lines.value, Math.max( 1, passed + 1 ) )
}

/**
 * The signature interaction: the reading surface is the stop key. A player with
 * both hands on the neck cannot aim at a control, so the whole tab is the target.
 * A real text selection is left alone.
 */
function tapTab() {
    const selection = window.getSelection && window.getSelection().toString()
    if ( selection ) return
    if ( !transport.running.value && host.value ) host.value.scrollLeft = 0
    transport.toggle()
}

onMounted( () => {
    window.addEventListener( 'scroll', trackPosition, { passive: true } )
    window.addEventListener( 'resize', measureViewport )
    measureViewport()
    trackPosition()
} )

onBeforeUnmount( () => {
    window.removeEventListener( 'scroll', trackPosition )
    window.removeEventListener( 'resize', measureViewport )
} )
</script>

<template>
<div class="surface" :class="{ playing: transport.running.value, browsing: listsOpen }" v-if="tab">
    <header class="file" :class="{ compact }">
        <div class="controls">
            <router-link to="/" class="legend">[ &lt;- LIBRARY ]</router-link>
            <a v-if="metadata.url" :href="metadata.url" target="_blank" rel="noopener" class="legend">[ LYRICS ]</a>
            <router-link :to="`/edit/${route.params.id}`" class="legend">[ EDIT ]</router-link>
            <Bookmarks :tab="tab" @open="listsOpen = $event" />
        </div>

        <h1 class="title">{{ tab.title }}</h1>
        <dl class="meta" v-if="!compact">
            <template v-if="tab.artist">
                <dt>artist</dt><dd>{{ tab.artist }}</dd>
            </template>
            <template v-if="tab.album">
                <dt>album</dt><dd>{{ tab.album }}</dd>
            </template>
            <dt>grid</dt>
            <dd>
                {{ columns }} cols &middot; {{ lines }} lines<template v-if="condensed"> &middot; narrowed</template>
                <span class="turn" v-if="tight"> &middot; turn the device for full size</span>
            </dd>
        </dl>
        <p class="turn compact-turn" v-if="compact && tight">turn the device for full size</p>
    </header>

    <div class="frame" ref="host" @click="tapTab">
        <pre
            ref="grid"
            class="tab"
            :style="{ fontSize: fontSize.toFixed( 2 ) + 'px' }"
        >{{ content }}</pre>
    </div>

    <div class="edge" v-if="tight" aria-hidden="true"></div>

    <div class="anchor" v-show="transport.running.value" aria-hidden="true"></div>

    <Transport
        :running="transport.running.value"
        :at-end="transport.atEnd.value"
        :lines-per-minute="transport.linesPerMinute.value"
        :step-index="transport.stepIndex.value"
        :steps="transport.steps"
        :line="currentLine"
        :lines="lines"
        @toggle="transport.toggle"
        @faster="transport.faster"
        @slower="transport.slower"
        @smaller="setScale( scale - 0.1 )"
        @bigger="setScale( scale + 0.1 )"
    />
</div>

<div class="surface missing" v-else>
    <header class="file" :class="{ compact }">
        <div class="controls">
            <router-link to="/" class="legend">[ &lt;- LIBRARY ]</router-link>
        </div>
        <h1 class="title">Not in your library</h1>
        <p class="prose">
            This tab has been deleted, or the link came from an account that is not signed in here.
            Nothing was lost from your library.
        </p>
    </header>
</div>
</template>

<style scoped>
.surface {
    min-height: 100vh;
    padding-bottom: 6rem;
    background: var(--tf-ground);
    color: var(--tf-ink);
    font-family: var(--tf-grid);
}

.file {
    padding: 0.5rem 0.75rem 1.1rem;
    border-bottom: 1px solid var(--tf-rule);
    transition: opacity 0.4s var(--tf-ease);
}

.controls {
    display: flex;
    flex-wrap: nowrap;
    align-items: center;
    font-size: 0.8125rem;
    margin-bottom: 0.9rem;
}

.legend {
    display: inline-block;
    font-size: 0.9375rem;
    color: var(--tf-legend);
    text-decoration: none;
    white-space: nowrap;
    padding: 0.6rem 0.4rem;
    min-height: 44px;
    line-height: 1.9;
    transition: color 0.18s var(--tf-ease);
}

.controls > .legend:first-child { padding-left: 0; }
.legend:hover { color: var(--tf-ink); text-decoration: none; }
.legend:focus-visible { outline: 1px solid var(--tf-live); outline-offset: 2px; }

.title {
    font-family: var(--tf-grid);
    font-size: 1.375rem;
    font-weight: 700;
    line-height: 1.2;
    letter-spacing: -0.01em;
    color: var(--tf-ink);
    margin: 0 0 0.6rem;
}

.meta {
    display: grid;
    grid-template-columns: max-content 1fr;
    gap: 0.1rem 1.25rem;
    margin: 0;
    font-size: 0.8125rem;
}

.meta dt { color: var(--tf-faint); }
.meta dd { margin: 0; color: var(--tf-legend); }

.prose {
    max-width: 62ch;
    margin: 0;
    font-size: 0.9375rem;
    line-height: 1.6;
    color: var(--tf-legend);
}

/* The scroll frame. It owns the width the grid is measured against. */
.frame {
    padding: 1.1rem 0.75rem 0;
    overflow-x: auto;
    overscroll-behavior-x: contain;
    cursor: pointer;
    -webkit-tap-highlight-color: transparent;
}

/* The grid itself. Nothing here may alter character advance or wrapping. */
.tab {
    /* Left, on the same gutter as the header: the surface reads as one file. */
    margin: 0;
    width: max-content;
    padding: 0;
    font-family: var(--tf-grid);
    line-height: 1.35;
    letter-spacing: normal;
    word-spacing: normal;
    font-variant-ligatures: none;
    font-feature-settings: "liga" 0, "calt" 0;
    tab-size: 8;
    white-space: pre;
    background: none;
    border: 0;
    color: var(--tf-ink);
}

.turn { color: var(--tf-live); }

/* Chrome recedes while the transport runs: the grid commands the screen.
   The lists panel borrows the same state, so an open menu reads as a layer
   over receded chrome rather than as clipped text. */
.surface.playing .file { opacity: 0.32; }
.surface.browsing .title,
.surface.browsing .meta { opacity: 0.18; transition: opacity 0.25s var(--tf-ease); }
.surface.playing .meta dt,
.surface.playing .meta dd { color: var(--tf-receded); }

.file.compact { padding-bottom: 0.5rem; }
.file.compact .controls { margin-bottom: 0.35rem; }
.file.compact .title { font-size: 1rem; margin-bottom: 0; display: inline-block; }
.compact-turn { display: inline; margin: 0 0 0 0.75rem; font-size: 0.8125rem; }

.edge {
    position: fixed;
    top: 0;
    bottom: 0;
    right: 0;
    width: 1px;
    background: var(--tf-rule);
    pointer-events: none;
    z-index: 10;
}

.anchor {
    position: fixed;
    left: 0;
    right: 0;
    top: 38vh;
    height: 1px;
    background: var(--tf-live);
    opacity: 0.42;
    pointer-events: none;
    z-index: 20;
}

.missing .file { border-bottom: 0; }

@media (min-width: 900px) {
    .file { padding: 1rem 1.5rem 1.4rem; }
    .frame { padding: 1.5rem 1.5rem 0; }
    .title { font-size: 1.75rem; }
}

@media (prefers-reduced-motion: reduce) {
    .file, .legend { transition: none; }
}
</style>
