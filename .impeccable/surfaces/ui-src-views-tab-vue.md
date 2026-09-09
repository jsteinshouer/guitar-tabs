---
version: 1
slug: "ui-src-views-tab-vue"
primary_target: "ui/src/views/Tab.vue"
related_targets: ["ui/src/components/AutoScroll.vue"]
---

# Surface brief — Playing surface (`ui/src/views/Tab.vue`)

Scope: the tab reading/playing screen and its transport. Visitor mode: **Operate**.

Audience: a player with the guitar in their hands, device on a stand at ~70cm, often dim light, frequently mid-song. Job: read the grid and get their hands back on the neck. Action: start/stop the scroll and set its speed without aiming.

Proof/content: the user's own tabs; widest seeded line is 84 characters. Genius supplies artist/album/artwork/lyrics URL when a song is attached, and nothing when it is not.

Constraints: Vue 3 binding; Pico CSS replaceable; dark ground + `#d0eb55` pinned; column alignment inviolable.

Memorable moment: tap the tab anywhere to stop the scroll — the reading surface is the control.

## Direction contract

THESIS: The plaintext tab is the whole design language — grid, rules, header block, transport and controls all set in the notation's own vocabulary. Refuses the card-and-icon-toolbar arrangement every tab site ships.

OWN-WORLD: Near-black ground (`#0b0c0a`), bone body text (`#e8e6dd`), dim legends (`#5c6152`), lime `#d0eb55` reserved for what is live. Rules are bar pipes and dash runs; no borders, cards, shadows, or icons where a legend can be set in the grid.

STORY: The player opens a song, the grid fits their screen exactly, they start the scroll, and they never touch the device again until the song ends.

FIRST VIEWPORT: Portrait, device on a stand. A labeled header block (title, artist, album) set in the grid; the tab body full-bleed edge to edge, type size derived from its widest line; a monospace transport row fixed to the bottom safe area — `[PLAY]`, a dash-scale speed control showing its real value, and a position counter in fixed digit slots. Lime current-line anchor. Chrome recedes to lowest legend contrast while running.

FORM: The Tab File — candidate 1 of the ordered grounded list, taken as IMPECCABLE'S PICK over the roll's assignment; seed key 547541de.

FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance
