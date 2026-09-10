import { ref, watch, onMounted, onBeforeUnmount } from 'vue'

/**
 * One propagating constraint: the widest line in the tab decides the type size,
 * and everything on the surface is measured from it.
 *
 * The grid is measured, never guessed — the advance width of the face in use is
 * read off the page, so a font that swaps in late re-fits instead of overflowing.
 *
 * When the fitted size falls under the size a player can read at arm's length,
 * the variable face is narrowed on its width axis to buy columns back. Some tabs
 * are simply wider than a portrait phone: `tight` says so, and the surface tells
 * the player the one thing that fixes it rather than silently shrinking.
 */
const LEGIBLE = 14   // px; below this a tab is not readable at a music stand
const MAX = 20       // px; above this a wide screen shows a billboard, not a song

export function useFitToGrid( content, { min = 8, max = MAX, legible = LEGIBLE } = {} ) {
    const host = ref( null )    // the scroll frame, measured for available width
    const grid = ref( null )    // the <pre> itself, measured for advance width
    const fontSize = ref( 14 )
    const columns = ref( 0 )
    const condensed = ref( false )
    const tight = ref( false )
    const scale = ref( readScale() )

    let observer = null

    function readScale() {
        try {
            const stored = Number( localStorage.getItem( 'tabfile.scale' ) )
            return Number.isFinite( stored ) && stored > 0 ? stored : 1
        }
        catch ( e ) {
            return 1
        }
    }

    function widestLine( text ) {
        let widest = 0
        for ( const line of String( text || '' ).split( '\n' ) ) {
            // Tabs would lie about their own width; expand them the way <pre> renders them.
            const expanded = line.replace( /\t/g, '        ' ).replace( /\s+$/, '' )
            if ( expanded.length > widest ) widest = expanded.length
        }
        return widest || 1
    }

    /** Advance width of one character, in ems, for the face actually rendering. */
    function measureAdvance( el ) {
        const probe = document.createElement( 'span' )
        const style = getComputedStyle( el )
        probe.style.cssText = 'position:absolute;visibility:hidden;white-space:pre;left:-9999px;top:0;'
        probe.style.fontFamily = style.fontFamily
        probe.style.fontWeight = style.fontWeight
        probe.style.fontStretch = style.fontStretch
        probe.style.letterSpacing = style.letterSpacing
        probe.style.fontSize = '200px'
        probe.textContent = '0'.repeat( 50 )
        document.body.appendChild( probe )
        const advance = probe.getBoundingClientRect().width / 50 / 200
        probe.remove()
        return advance || 0.5
    }

    function fit() {
        const frame = host.value
        const pre = grid.value
        if ( !frame || !pre ) return

        const cols = widestLine( content.value )
        columns.value = cols

        const style = getComputedStyle( frame )
        const available = frame.clientWidth
            - parseFloat( style.paddingLeft || 0 )
            - parseFloat( style.paddingRight || 0 )
        if ( available <= 0 ) return

        pre.style.fontStretch = 'normal'
        let exact = available / ( cols * measureAdvance( pre ) )
        condensed.value = false

        // The face carries a real width axis; use it before giving up legibility.
        if ( exact * scale.value < legible ) {
            pre.style.fontStretch = '75%'
            const narrowed = available / ( cols * measureAdvance( pre ) )
            if ( narrowed > exact ) {
                exact = narrowed
                condensed.value = true
            }
            else {
                pre.style.fontStretch = 'normal'
            }
        }

        const fitted = Math.min( max, exact )

        // The floor is the promise: a grid that cannot fit at a size readable from
        // a music stand is panned, not shrunk. Sub-floor sizes are the player's
        // explicit choice through [A-], never the default.
        const base = fitted < legible ? legible : fitted

        fontSize.value = Math.max( min, Math.min( max, base * scale.value ) )
        tight.value = fitted < legible
    }

    function setScale( next ) {
        scale.value = Math.max( 0.7, Math.min( 2, Number( next.toFixed( 2 ) ) ) )
        try {
            localStorage.setItem( 'tabfile.scale', String( scale.value ) )
        }
        catch ( e ) { /* private mode: the size still applies for this session */ }
        fit()
    }

    onMounted( () => {
        fit()
        if ( window.ResizeObserver ) {
            observer = new ResizeObserver( fit )
            if ( host.value ) observer.observe( host.value )
        }
        window.addEventListener( 'orientationchange', fit )
        // The vendored face swaps in after first paint; re-fit against its real advance.
        if ( document.fonts && document.fonts.ready ) document.fonts.ready.then( fit )
    } )

    onBeforeUnmount( () => {
        if ( observer ) observer.disconnect()
        window.removeEventListener( 'orientationchange', fit )
    } )

    watch( content, fit )

    return { host, grid, fontSize, columns, condensed, tight, scale, setScale, fit }
}
