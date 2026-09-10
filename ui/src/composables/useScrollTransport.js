import { ref, computed, onBeforeUnmount } from 'vue'

/**
 * The transport. Speed is carried in lines per minute, because that is the unit
 * a player can reason about, and it is shown rather than hidden in a setting.
 *
 * Motion is a per-frame accumulator, not a queue of smooth scrolls: at one pixel
 * every hundred milliseconds the browser's own smoothing produces judder, and
 * queued animations fight the player the moment they touch the screen.
 */
const STEPS = [ 4, 6, 8, 10, 13, 16, 20, 25, 32, 40 ]

export function useScrollTransport( { lineHeight } ) {
    const running = ref( false )
    const stepIndex = ref( readStep() )
    const atEnd = ref( false )

    let frame = null
    let last = 0
    let carry = 0

    const reduced = window.matchMedia
        ? window.matchMedia( '(prefers-reduced-motion: reduce)' )
        : { matches: false }

    const linesPerMinute = computed( () => STEPS[ stepIndex.value ] )

    function readStep() {
        try {
            const raw = localStorage.getItem( 'tabfile.speed' )
            if ( raw === null || raw === '' ) return 3   // Number(null) is 0, which is a real step
            const stored = Number( raw )
            return Number.isInteger( stored ) && stored >= 0 && stored < STEPS.length ? stored : 3
        }
        catch ( e ) {
            return 3
        }
    }

    function persistStep() {
        try {
            localStorage.setItem( 'tabfile.speed', String( stepIndex.value ) )
        }
        catch ( e ) { /* nothing to recover from; the speed still applies now */ }
    }

    function atBottom() {
        const max = document.documentElement.scrollHeight - window.innerHeight
        return window.scrollY >= max - 1
    }

    function tick( now ) {
        if ( !running.value ) return

        const elapsed = last ? Math.min( now - last, 250 ) : 0
        last = now

        const perSecond = ( linesPerMinute.value / 60 ) * lineHeight()
        carry += ( perSecond * elapsed ) / 1000

        const whole = Math.floor( carry )
        if ( whole >= 1 ) {
            carry -= whole
            window.scrollBy( 0, whole )
        }

        if ( atBottom() ) {
            atEnd.value = true
            stop()
            return
        }

        frame = requestAnimationFrame( tick )
    }

    /** Reduced motion: advance a whole line at a time instead of gliding. */
    function stepTick() {
        if ( !running.value ) return
        window.scrollBy( 0, lineHeight() )
        if ( atBottom() ) {
            atEnd.value = true
            stop()
            return
        }
        frame = window.setTimeout( stepTick, 60000 / linesPerMinute.value )
    }

    function start() {
        if ( running.value ) return
        if ( atBottom() ) return
        running.value = true
        atEnd.value = false
        last = 0
        carry = 0
        frame = reduced.matches
            ? window.setTimeout( stepTick, 60000 / linesPerMinute.value )
            : requestAnimationFrame( tick )
    }

    function stop() {
        running.value = false
        if ( frame !== null ) {
            if ( reduced.matches ) window.clearTimeout( frame )
            else cancelAnimationFrame( frame )
            frame = null
        }
    }

    function toggle() {
        running.value ? stop() : start()
    }

    function faster() {
        if ( stepIndex.value < STEPS.length - 1 ) stepIndex.value++
        persistStep()
    }

    function slower() {
        if ( stepIndex.value > 0 ) stepIndex.value--
        persistStep()
    }

    onBeforeUnmount( stop )

    return {
        running, atEnd, stepIndex, linesPerMinute,
        steps: STEPS.length,
        start, stop, toggle, faster, slower
    }
}
