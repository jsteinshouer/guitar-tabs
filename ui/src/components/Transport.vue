<script setup>
import { computed } from 'vue'

const props = defineProps( {
    running: Boolean,
    atEnd: Boolean,
    linesPerMinute: Number,
    stepIndex: Number,
    steps: Number,
    line: Number,
    lines: Number
} )

defineEmits( [ 'toggle', 'faster', 'slower', 'smaller', 'bigger' ] )

/** The speed scale is drawn from the notation's own characters. */
const scale = computed( () => {
    let out = ''
    for ( let i = 0; i < props.steps; i++ ) out += i === props.stepIndex ? '|' : '-'
    return out
} )

const pad = ( n, width ) => String( Math.max( 0, n ) ).padStart( width, '0' )
const counter = computed( () => `${pad( props.line, 3 )}/${pad( props.lines, 3 )}` )
</script>

<template>
<div class="transport">
    <button
        class="key play"
        :class="{ live: running }"
        :aria-pressed="running"
        :aria-label="running ? 'Stop scrolling' : 'Start scrolling'"
        @click="$emit('toggle')"
    >{{ atEnd && !running ? '[ END  ]' : running ? '[ STOP ]' : '[ PLAY ]' }}</button>

    <div class="speed">
        <button class="key step" aria-label="Slower" @click="$emit('slower')">[-]</button>
        <span class="scale" aria-hidden="true">{{ scale }}</span>
        <span class="value">{{ linesPerMinute }}<span class="unit">lpm</span></span>
        <button class="key step" aria-label="Faster" @click="$emit('faster')">[+]</button>
    </div>

    <div class="size">
        <button class="key step" aria-label="Smaller type" @click="$emit('smaller')">[A-]</button>
        <button class="key step" aria-label="Larger type" @click="$emit('bigger')">[A+]</button>
    </div>

    <span class="counter" :aria-label="`Line ${line} of ${lines}`">{{ counter }}</span>
</div>
</template>

<style scoped>
.transport {
    position: fixed;
    left: 0;
    right: 0;
    bottom: 0;
    z-index: 40;
    display: flex;
    align-items: center;
    gap: 0.75rem;
    padding: 0.35rem 0.6rem calc(0.35rem + env(safe-area-inset-bottom));
    background: var(--tf-ground);
    border-top: 1px solid var(--tf-rule);
    font-family: var(--tf-grid);
    font-size: 0.8125rem;
    color: var(--tf-legend);
}

.key {
    font-family: inherit;
    font-size: inherit;
    color: var(--tf-legend);
    background: none;
    border: 0;
    padding: 0 0.35rem;
    min-height: 44px;
    cursor: pointer;
    white-space: nowrap;
    transition: color 0.18s var(--tf-ease);
}

.key:hover { color: var(--tf-ink); }
.key:focus-visible { outline: 1px solid var(--tf-live); outline-offset: 2px; }

.play {
    font-weight: 700;
    letter-spacing: 0.02em;
    color: var(--tf-ink);
    padding-left: 0;
    min-width: 5.5em;
    text-align: left;
}

.play.live { color: var(--tf-live); }

.speed {
    display: flex;
    align-items: center;
    gap: 0.3rem;
    min-width: 0;
}

.scale {
    color: var(--tf-faint);
    letter-spacing: 0.06em;
    overflow: hidden;
    white-space: nowrap;
}

.value {
    font-variant-numeric: tabular-nums;
    color: var(--tf-legend);
    white-space: nowrap;
}

.unit {
    color: var(--tf-faint);
    margin-left: 0.4em;
}

.size { display: flex; margin-left: auto; }

.counter {
    font-variant-numeric: tabular-nums;
    color: var(--tf-faint);
    white-space: nowrap;
}

@media (max-width: 420px) {
    .transport { gap: 0.35rem; font-size: 0.75rem; }
    .scale { letter-spacing: 0.01em; }
    .size { margin-left: auto; }
}
</style>
