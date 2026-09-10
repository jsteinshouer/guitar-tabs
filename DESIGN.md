---
name: The Tab File
description: A plaintext-notation world for the whole app — the grid sets the type, dash runs are the only rules, lime marks what is live.
colors:
  ground: "#0b0c0a"
  ink: "#e8e6dd"
  legend: "#8b917c"
  faint: "#7c8370"
  receded: "#5c6152"
  rule: "#1e2119"
  live: "#d0eb55"
  alarm: "#ff8b7a"
typography:
  title:
    fontFamily: "Inconsolata, ui-monospace, SFMono-Regular, Menlo, Consolas, Liberation Mono, monospace"
    fontSize: "1.375rem"
    fontWeight: 700
    lineHeight: 1.2
    letterSpacing: "-0.01em"
  headline:
    fontFamily: "Inconsolata, ui-monospace, SFMono-Regular, Menlo, Consolas, Liberation Mono, monospace"
    fontSize: "1.125rem"
    fontWeight: 700
    lineHeight: 1.2
    letterSpacing: "-0.01em"
  grid:
    fontFamily: "Inconsolata, ui-monospace, SFMono-Regular, Menlo, Consolas, Liberation Mono, monospace"
    fontSize: "14px-20px (fitted)"
    fontWeight: 400
    lineHeight: 1.35
    letterSpacing: "normal"
    fontFeature: "\"liga\" 0, \"calt\" 0"
  legend:
    fontFamily: "Inconsolata, ui-monospace, SFMono-Regular, Menlo, Consolas, Liberation Mono, monospace"
    fontSize: "0.9375rem"
    fontWeight: 400
    lineHeight: 1.9
  body:
    fontFamily: "Inconsolata, ui-monospace, SFMono-Regular, Menlo, Consolas, Liberation Mono, monospace"
    fontSize: "0.9375rem"
    fontWeight: 400
    lineHeight: 1.4
  entry:
    fontFamily: "Inconsolata, ui-monospace, SFMono-Regular, Menlo, Consolas, Liberation Mono, monospace"
    fontSize: "1.0625rem"
    fontWeight: 400
    lineHeight: 1.5
  label:
    fontFamily: "Inconsolata, ui-monospace, SFMono-Regular, Menlo, Consolas, Liberation Mono, monospace"
    fontSize: "0.8125rem"
    fontWeight: 400
    lineHeight: 1.4
rounded:
  none: "0"
spacing:
  xs: "0.35rem"
  sm: "0.6rem"
  gutter: "0.75rem"
  md: "1.1rem"
  gutter-wide: "1.5rem"
  page-cap: "56rem"
  tap: "44px"
components:
  key:
    textColor: "{colors.legend}"
    typography: "{typography.label}"
    rounded: "{rounded.none}"
    padding: "0 0.35rem"
    height: "{spacing.tap}"
  key-hover:
    textColor: "{colors.ink}"
  key-live:
    textColor: "{colors.live}"
  legend:
    textColor: "{colors.legend}"
    typography: "{typography.legend}"
    rounded: "{rounded.none}"
    padding: "0.6rem 0.4rem"
    height: "{spacing.tap}"
  legend-hover:
    textColor: "{colors.ink}"
  legend-primary:
    textColor: "{colors.ink}"
  legend-live:
    textColor: "{colors.live}"
  legend-working:
    textColor: "{colors.live}"
  legend-alarm-hover:
    textColor: "{colors.alarm}"
  legend-destroy:
    textColor: "{colors.alarm}"
  legend-disabled:
    textColor: "{colors.faint}"
  panel-row:
    backgroundColor: "{colors.ground}"
    textColor: "{colors.ink}"
    typography: "{typography.body}"
    rounded: "{rounded.none}"
    padding: "0.55rem 0.75rem"
    height: "{spacing.tap}"
  panel-row-hover:
    textColor: "{colors.live}"
  list-entry:
    textColor: "{colors.ink}"
    typography: "{typography.entry}"
    rounded: "{rounded.none}"
    padding: "0.5rem 0"
    height: "{spacing.tap}"
  list-entry-hover:
    textColor: "{colors.live}"
  field:
    backgroundColor: "{colors.ground}"
    textColor: "{colors.ink}"
    typography: "{typography.body}"
    rounded: "{rounded.none}"
    padding: "0.55rem 0"
    height: "{spacing.tap}"
  input-inline:
    backgroundColor: "{colors.ground}"
    textColor: "{colors.ink}"
    typography: "{typography.body}"
    rounded: "{rounded.none}"
    padding: "0.5rem 0"
---

# Design System: The Tab File

> **Scope.** This world governs **the whole application**. `ui/src/assets/tabfile.scss`
> is the app's only base stylesheet — tokens, the vendored `@font-face`, the reset, form
> fields, and the shared classes `.legend`, `.legend-row`, `.rule`, `.seam`, `.field`,
> `.prose`, `.page`, `.page-head`, `.count`, `.alarm-text`. Every view is in-world: nav,
> library, tab form, list, login, song search, scrape, and the playing surface. There is
> no CSS framework underneath it. Pico CSS and Bootstrap Icons were removed with their
> theme files and package dependencies; the shipped bundle's CSS fell by 141KB to ~14.7KB
> and 306KB of icon fonts left with them.

## Overview

**Creative North Star: "The Tab File"**

The plaintext tab is the whole design language. Not a theme applied to a tab, but the
notation itself promoted to a visual system: the character grid sets the type size, bar
pipes and dash runs are the only rules, controls are legends typed in square brackets,
and one lime marks exactly what is live. The world refuses the arrangement every tab site
ships — the card, the icon toolbar, the chrome that competes with the song.

Density is a consequence of the job, not a style. The governing scene is a phone on a
music stand at arm's length with both hands on the instrument, so the playing surface
spends its whole width on the grid, holds a 14px legible floor, and puts every control on
a 44px target that never needs to be aimed at. The signature move is that the reading
surface *is* the stop key: tapping the tab anywhere toggles the scroll. Away from the
grid, the same file discipline holds: the library is a listing where each entry states its
own column count, forms are labelled lines with a hairline under each field, and a
destructive confirmation opens **in flow** rather than as a modal over a dimmed page.

The ground is near-black and the ink is bone, because dim rehearsal light is the normal
case. Everything that is not the notation sits in one of three muted greens and steps back
further while the transport runs. Nothing is raised, tinted, or shadowed anywhere in the
app.

**Key Characteristics:**
- Monospace-only: one face, Inconsolata, vendored and offline-capable, with no framework
  CSS beneath it.
- The widest line in the tab decides the type size for the playing surface.
- Flat and borderless by intent; the only strokes are 1px hairline seams and typed dash runs.
- Lime `#d0eb55` is state, never decoration — which is why a screen's primary action is
  bone at weight 700, not lime.
- Bracketed word-legends instead of glyph icons, everywhere.

## Colors

A near-black ground with bone ink, three muted olive-greens for everything that is not
the notation, and a single lime that only ever means "live".

### Primary
- **Signal Lime** (`#d0eb55`): the live channel. It is the running `[ STOP ]` key, the
  fixed current-line anchor at 38vh, every `:focus-visible` outline, the caret in every
  field and the focused field's underline, hovered rows and entries, the held `[ SAVED ]`
  state, `::selection`, the "turn the device for full size" hint, and any control that is
  disabled **because it is working** (`[ SAVING ]`, `[ DELETING ]`, `[ SEARCHING ]`,
  `[ LOOKING ]`, which computes rgb(208,235,85) in the running state). It appears nowhere
  as ornament.

### Neutral
- **Stage Black** (`#0b0c0a`): the ground of every surface — html, body, nav bar, page
  shell, both lists panels, the transport. One background value across the whole app;
  there is no second surface tone.
- **Bone** (`#e8e6dd`): body ink at full strength — the tab grid, headings, listing entry
  names, panel rows, typed input, the nav brand, and the primary action on any screen.
- **Legend Green** (`#8b917c`): the resting colour of controls and metadata values —
  legends, transport keys, panel box columns, `.prose`, the lpm value.
- **Faint Green** (`#7c8370`): the quietest resting text — field labels and hints,
  metadata terms, entry credits and column counts, the `.count` in a page head, the speed
  scale, the position counter, placeholders, and every disabled legend and row. Measured
  at **4.98:1** on the ground; this is the floor for text that rests on screen.
- **Rule Green** (`#1e2119`): strokes only — the nav seam, header and transport seams,
  the underline beneath every field at rest, the fixed right edge marker, typed dash runs,
  the scrollbar track.
- **Receded Green** (`#5c6152`): metadata text **only while the transport is running**.
  It is below the resting contrast floor and is earned by being transient: the player is
  reading the grid, not the header.

### Tertiary
- **Alarm Coral** (`#ff8b7a`): the warm value, one line or one control at a time. It
  carries every error line (`.alarm-text`), the hover of an opener that is not yet
  destructive (`.legend.alarm`), and the resting colour of a confirmed irreversible action
  (`.legend.destroy`, which computes rgb(255,139,122) on the shipped confirm step).

### Named Rules
**The One Live Colour Rule.** Lime means live. If an element is not running, focused,
selected, hovered, or currently held, it is not lime. A screen's primary action is
therefore Bone at weight 700 — never lime, because it is not running yet.

**The Working Reads Live Rule.** A control disabled *because it is working* outranks
disabled: it is the one thing on the screen that is actually running, so it reads lime.
`.legend.working` is declared after `.legend[disabled]` at equal specificity so it wins
the cascade. Ordinary disabled controls fall to Faint Green.

**The Resting Floor Rule.** Text that rests on screen sits at Faint Green (4.98:1) or
above. Receded Green is legal only inside a transient running state and never for a label
the player must read to act.

**The Single Ground Rule.** There is one background value in the app. Depth is never
expressed by tinting a panel lighter than the ground.

## Typography

**Grid / Display / Body / Label Font:** Inconsolata — one variable face for the entire
world (weight axis 400–700, width axis 75–100%), vendored as a latin-subset woff2 under
`ui/src/assets/fonts/` with its OFL licence, so the app works with no network at
rehearsal. Fallback is the platform mono stack (`ui-monospace`, SF Mono, Menlo, Consolas,
Liberation Mono). It is set once on `body` via `--tf-grid` and inherited everywhere; no
view declares a second family.

**Character:** A typewriter that learned to set headlines. Because the notation is
monospaced, everything else is too; hierarchy comes from size, weight, and colour rather
than from a second family. There is no display face and no proportional face in this world.

### Hierarchy
- **Grid** (400, fitted 14–20px, 1.35): the tab body. Size is computed, never authored —
  see The Fit Rule. Ligatures and contextual alternates are disabled and letter/word
  spacing are held at `normal`, because character advance is the layout. The tab form's
  `<textarea>` inherits the same discipline at 0.875rem with `white-space: pre` and
  `tab-size: 8`, so pasted spacing survives editing.
- **Title** (700, 1.375rem / 1.75rem at ≥900px on the playing surface, 1.2, −0.01em): the
  `h1` of every page and the song title. Collapses to 1rem inline on short viewports
  (<520px tall) on the playing surface only.
- **Headline** (700, 1.125rem): the `h2` of an empty, no-match, or missing-record state,
  and the song-finder head.
- **Legend** (400, 0.9375rem, line-height 1.9): every bracketed control in the app. The
  size is authored once on `.legend`; the nav no longer leaks a size into it.
- **Entry** (400, 1.0625rem, 1.5): the name of a tab in a listing or a search hit — the
  one step above body, because the title is what the eye is scanning for.
- **Body** (400, 0.9375rem, 1.4): fields, panel rows, and `.prose` (capped at 62ch, 1.6).
- **Label** (400, 0.8125rem; 0.75rem below 420px on the transport): field labels and
  hints, metadata rows, entry credits and column counts, page-head counts, transport keys,
  speed scale, position counter, error text.

### Named Rules
**The Fit Rule.** The widest line in the tab sets the type size for the grid. The advance
width of the face actually rendering is measured off the page — never assumed — and re-fit
on resize, orientation change, and font load. The fitted size is clamped to a **20px
reading cap**; a wide screen shows a song, not a billboard.

**The Legible Floor Rule.** 14px is the floor. If the tab cannot fit at 14px, the variable
width axis narrows to 75% to buy columns back; if it still will not fit, the grid is
**panned, not shrunk** — the surface says "turn the device for full size" and lets the
player scroll horizontally. Sub-floor sizes exist only as the player's explicit `[A-]`
choice. Shipped: 14px at 390px portrait (width-narrowed), 19.45px at 844px landscape,
20px at 1440px desktop.

**The Typed Control Rule.** Controls are words in square brackets set in the grid face —
`[ PLAY ]`, `[ STOP ]`, `[ SAVE ]`, `[ SAVING ]`, `[ DELETE LIST ]`, `[ KEEP IT ]`,
`[ CLEAR SEARCH ]`, `[-]`, `[+]`, `[A-]`, `[A+]`, `[x]`, `[>]`, `[ ]`. A control's verb
changes to state what it is doing while it works. Numbers that change live are fixed-width:
`tabular-nums` plus zero-padded slots (`003/128`), so nothing reflows while the player is
reading.

## Layout

**Page shell.** Every non-playing route is a `.page`: `1.1rem` top padding, the gutter left
and right, `4rem` at the foot, capped at **56rem**. The cap is a measure limit, not a
centring device — the left edge stays pinned to the gutter at every width, so a wide
desktop reads as a wider file, never as a column floating in space. `.page-head` sets the
`h1` on a baseline against a right-aligned `.count`. The only page that narrows further is
the login gate (26rem, 3rem top padding), which is a single short form and still left-pinned.

**The playing surface** owns the whole window: the global nav is suppressed on `/tab/:id`,
the surface sets its own `min-height: 100vh` and reserves `6rem` of bottom padding so the
fixed transport never covers the last lines. Vertical order there is fixed: header block
(controls row, title, metadata definition list), scroll frame holding the `<pre>` grid,
then the transport pinned to the bottom safe area (`env(safe-area-inset-bottom)`).

**Nav.** A sticky one-line bar on the ground: brand left in bone at weight 700 pushed
against `margin-right: auto`, then `[ NEW ]`, `[ LISTS ]`, `[ MORE ]`, closed by a full-width
1px `.seam`. Below **520px** the brand shortens from `GUITAR TABS` to `TABS` and the bar's
gap collapses to zero, which is what keeps four controls on one line at 390px.

**Gutter.** One gutter, `0.75rem`, widening to `1.5rem` at ≥900px, shared by the nav, every
page, the playing-surface header, and the grid. That shared edge is what makes the app read
as one file rather than a set of boxed screens.

**Rhythm.** Spacing steps are small and few: 0.35rem inside keys, 0.6rem around legends,
the 0.75rem gutter, ~0.9rem between a page head and its content, 1.1rem above the grid,
1.4rem between fields, 2.5rem before a destructive footer, 1.5rem gutter at desktop.

**Density breakpoints.** Three, all behavioural rather than cosmetic: at **520px** wide the
nav brand shortens; at viewport height **<520px** the playing surface collapses its header
to one inline line and drops the metadata list; at **≤420px** the transport tightens its
gaps and drops to 0.75rem. The only other width query is **900px**, which changes gutter
and playing-surface title size only.

**Targets.** Every interactive element carries `min-height: 44px`, including fields. This
is a hard floor from the usage scene, not a comfort setting.

**Search placement (known trade).** Search lives on the Library page at full gutter width,
not in the nav, so the notation-first bar stays one line and the search field can be as wide
as the results it filters. The accepted cost: there is no search entry point from another
route; recovery is one tap on the brand.

### Named Rules
**The One Gutter Rule.** Nav, page, header, and grid share the same left edge at every
size. Nothing in this world is centred; width caps limit measure, they never float content
away from the gutter.

**The Untouched Advance Rule.** Nothing applied to the grid — rendered or being edited —
may alter character advance or wrapping: no letter-spacing, no word-spacing, no ligatures,
no wrapping. `white-space: pre` and `tab-size: 8` are inviolable; column alignment is the
product.

## Elevation & Depth

**This world is entirely flat. There are no shadows anywhere in the shipped build** — no
`box-shadow`, no blur, no scrim, no backdrop-filter, no tinted panel, on any route. Both
lists panels open directly onto the same ground as the surface behind them, positioned
rather than lifted.

Depth is expressed by **opacity and colour recession** instead. While the transport runs,
the playing surface's header block drops to 0.32 opacity; while its lists panel is open,
the title and metadata drop to 0.18, so an open menu reads as a layer over receded chrome
rather than as clipped text. Metadata values additionally shift to Receded Green while
running.

Separation, where it is needed at all, is a **1px hairline in Rule Green**: the nav seam,
the header seam, the transport top seam, the underline beneath each field, and a fixed 1px
right-edge marker on the grid. Inside panels and above destructive footers the same job is
done by a typed dash run rather than a border.

### Named Rules
**The Recede, Don't Cover Rule.** Chrome yields to the grid by fading, never by sliding
away or being covered by a scrim. Transitions run at 0.4s (chrome) / 0.25s (panel) /
0.18s (colour) on `cubic-bezier(0.16, 1, 0.3, 1)`, and all transitions and animations are
disabled app-wide under `prefers-reduced-motion: reduce`.

**The No Lift Rule.** Nothing in this world is lifted. If a surface needs to read as
separate, it recedes what is behind it or draws one hairline — it does not cast a shadow,
and it does not open as a modal dialog over a dimmed page.

## Shapes

**Radius is zero, everywhere.** No element in the shipped app has a corner radius; every
shared class sets `border-radius: 0` explicitly and there is no framework painting
underneath to override. Buttons have no background fill, no border, and no box-shadow —
they are bare text with padding, made legible as controls by their bracket glyphs and
their colour. Fields are equally bare: transparent, no border except a 1px Rule Green
underline that turns lime on focus.

The only geometry in the world is: the 1px hairline seam, the 1px field underline, the 1px
fixed edge marker, the 1px lime anchor line at 38vh, the 1px lime focus outline (offset
2px), and typed runs of `-`, `|`, and bracket characters drawn from the notation's own
character set. Rules are drawn as characters wherever the character can do the job; borders
are used only for structural seams and field underlines.

## Components

### Legend (the app's only button)
One class, `.legend`, carries every control in the app: inline-flex, 44px min-height,
`0.6rem 0.4rem` padding, no fill, no border, no radius, Legend Green at rest, Bone on
hover over 0.18s, 1px lime focus outline at 2px offset. `.legend-row` groups them on one
wrapping line and drops the first one's left padding onto the gutter. States, all
first-class:
- **`.primary`** — Bone at weight 700. A screen's principal action (`[ SAVE ]`, `[ SIGN IN ]`,
  `[ RUN IT ]`). Weight, not colour, because lime is reserved for live.
- **`.working`** — lime, declared after `[disabled]` so a control disabled while it works
  still reads as the running thing (`[ SAVING ]`, `[ DELETING ]`, `[ SEARCHING ]`).
- **`.live`** — lime; a held or currently-true state (`[ SAVED ]`, the running `[ STOP ]`).
- **`.alarm`** — Alarm Coral on hover only. The opener of a destructive flow, which is not
  itself destructive (`[ DELETE ]`, `[ DELETE LIST ]`).
- **`.destroy`** — Alarm Coral at rest. Only the confirmed, irreversible commit inside an
  opened confirmation.
- **`[disabled]`** — Faint Green, default cursor.

### Transport (signature component)
The bottom row of the playing surface: a fixed bar on the ground with a 1px top seam, one
flex line at 0.8125rem. `[ PLAY ]` sits left in bone at weight 700 in a fixed 5.5em slot so
the label swap to `[ STOP ]` / `[ END  ]` never shifts the row, and turns lime while
running. Speed is a `[-] ----|----- 13lpm [+]` group: a dash-run scale drawn
character-by-character with `|` at the current step, and the real value in lines per minute
— the unit a player can reason about. Type size `[A-] [A+]` is pushed right by
`margin-left: auto`. A zero-padded `003/128` counter in tabular figures closes the row.

### Library listing (signature component)
The library is **not** cards. Each tab is a two-column grid row — name left in Bone at
1.0625rem, its own column count right in Faint Green tabular figures (`84 cols`), and the
artist · album credit wrapped underneath in Faint Green — separated by nothing but rhythm,
44px min-height, `0.5rem 0` padding. Hovering or focusing the row turns the name lime. Every
entry states its own grid the way the playing surface states its fit decision.

### Panels (nav lists / more)
- **Corner style:** square (0). **Shadow:** none. **Border:** none.
- **Background:** the ground, absolutely positioned under the trigger, 15rem wide (16rem on
  the playing surface) capped to `calc(100vw - 1.5rem)` so it can never push the document
  wider than the screen.
- **Frame:** bracketed top and bottom by typed dash runs in Rule Green (`.rule`), clipped by
  overflow so the run never sizes the panel.
- **Rows:** full-width text at 0.875rem in Bone, 44px min-height, prefixed by a fixed
  `2.5em` box column carrying `[>]` / `[x]` / `[ ]` / `[+]` so every label starts on the
  same advance in either panel. Hover turns the row lime; empty and disabled rows are Faint
  Green with a default cursor.

### Inline confirmation (signature pattern)
Destructive confirmations are **in-flow panels, not `<dialog>` modals**. The opener
(`.legend.alarm`) is replaced in place by a `.prose` sentence naming the thing being
destroyed in Bone and stating the consequence, then a `.legend-row` of `[ KEEP IT ]` and the
`.legend.destroy` commit. Nothing dims, nothing overlays, and the page keeps its scroll
position. The Genius song finder follows the same rule: a dash-run-bracketed section that
opens inside the form, not over it.

### Inputs / Fields
- **Style:** transparent, no border but a 1px Rule Green underline, no radius, full width,
  `0.55rem 0` padding, 44px min-height, Bone text at 0.9375rem. `.field` wraps a
  `.label` (0.8125rem Faint Green) above the control with 1.4rem below.
- **Focus:** the outline is suppressed and the underline turns lime; the caret is lime on
  every field in the app.
- **Placeholder:** Faint Green. Search fields strip the WebKit cancel decoration.
- **Inline variant:** inside a panel, the field drops even its underline and aligns to the
  2.5em box column; the lime caret is the only focus signal.
- **Error:** one `.alarm-text` line at 0.8125rem near the control.

### Navigation
Sticky bar on the ground, legends only, closed by a `.seam`. The brand is a legend at
weight 700 in Bone with `letter-spacing: 0.02em` and no left padding, shortening to `TABS`
below 520px. Menus are `aria-expanded` buttons that open the panels above; opening one
closes the other. On `/tab/:id` the nav is not rendered at all — the playing surface carries
its own way back.

### Empty, missing, and error states
Every list-bearing route has one, and they share a form: an `h2` naming the situation
plainly, one `.prose` paragraph at 62ch in Legend Green explaining it, and one legend
offering the way out (`[ ADD THE FIRST TAB ]`, `[ CLEAR SEARCH ]`, `[ <- LIBRARY ]`). No
illustration, no icon, no seam. Error copy always states what was *not* changed — "Nothing
was changed", "your tab content is never touched" — so a failure never leaves the state
ambiguous.

## Do's and Don'ts

### Do:
- **Do** set every new element in Inconsolata via `var(--tf-grid)`. This world has exactly
  one face and no framework CSS beneath it — author every new element from the shared base
  in `tabfile.scss`.
- **Do** reach for the shared classes first: `.page`, `.page-head`, `.legend`,
  `.legend-row`, `.rule`, `.seam`, `.field`, `.prose`, `.count`, `.alarm-text`. A new view
  should add layout, not repaint the primitives.
- **Do** label controls as bracketed words (`[ EDIT ]`, `[x]`) rather than glyphs.
- **Do** give every interactive element `min-height: 44px`; the player is not aiming.
- **Do** make a screen's primary action `.legend.primary` (Bone, 700) and a working control
  `.legend.working` (lime), so weight carries emphasis and lime stays reserved for live.
- **Do** keep resting text at Faint Green (`#7c8370`, 4.98:1) or above, and reserve
  Receded Green for transient running states only.
- **Do** draw separators as typed dash runs inside components, and reserve 1px Rule Green
  hairlines for full-width structural seams and field underlines.
- **Do** use `tabular-nums` and fixed-width zero-padded slots for any number that changes
  while the player is reading.
- **Do** state a surface's own constraints (`narrowed`, `84 cols`, `turn the device for
  full size`) instead of silently degrading, and say what was not changed when something
  fails.
- **Do** open confirmations and finders in flow, and scope every component's styles.
- **Do** disable transitions under `prefers-reduced-motion: reduce`.

### Don't:
- **Don't** introduce a second font family, a proportional face, or a system display face.
- **Don't** add a corner radius, a filled button, a card, or a shadow — this world has no
  radius and no `box-shadow` at all. A library or list is a listing, never a card grid.
- **Don't** tint a panel lighter than the ground to signal layering; recede what is behind
  it instead.
- **Don't** open a `<dialog>` modal, a scrim, or an overlay for a confirmation; the flow
  happens in place.
- **Don't** use lime for anything that is not live, working, focused, selected, hovered, or
  held — including a primary action that has not started yet.
- **Don't** centre a page or float it off the gutter; cap the measure and keep the left edge.
- **Don't** apply letter-spacing, word-spacing, ligatures, or wrapping to the tab grid, in
  the reader or the editor; column alignment is inviolable.
- **Don't** let the grid render below 14px by default or above 20px at any width.
- **Don't** ship a glyph-icon toolbar, an icon font, an eyebrow, or a kicker above a
  heading; a heading stands alone above its prose.
- **Don't** ship an unscoped element selector from a component; base styling belongs in
  `tabfile.scss` and everything else is `<style scoped>`.
