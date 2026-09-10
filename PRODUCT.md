# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

A small, closed group: the owner and a handful of invited people (friends, bandmates). Everyone has an account; registration is not an open public funnel, so acquisition, marketing, and growth onboarding are out of scope. Every user is a player who already knows what a tab is.

The governing usage scene is a phone or tablet propped on a music stand at arm's length, with both hands on the instrument. Reading at distance and one-handed, imprecise touch input are the normal case, not the edge case. Desktop is a secondary scene used mostly for entering and editing tab content.

## Product Purpose

A personal guitar-tab library that is equally about **curating** and **playing**:

- Curate — collect, paste, edit, and organize the tabs you actually play, grouped into named bookmark lists (with "Favorites" as a built-in list), and enriched with real song metadata (artist, album, artwork, lyrics link) pulled from the Genius API.
- Play — read that tab hands-free while playing: fixed-width content that preserves alignment, an auto-scroll control, and a one-tap link to lyrics.

Success is that a player opens the app, finds the right tab in seconds, and plays the whole song without touching the device again.

## Positioning

Neither half stands alone, and the pairing is the point: it is *your* library — tabs you chose, pasted, and corrected yourself — presented in a form built for playing from rather than browsing. Public tab sites optimize for search and ad-supported discovery of everyone's tabs; a folder of text files has no organization, no metadata, and no hands-free reading. This is the trusted, edited set plus the playing surface.

## Operating Context

- Self-hosted via Docker Compose (`docker compose up`); SQLite database file on disk; test data loaded with `box migrate seed run`.
- Requires a Genius API key for song metadata; without it, tabs still work but arrive unenriched.
- Tab content is authored elsewhere and pasted in as plain text.
- Bulk enrichment is a deliberate, user-triggered operation ("Scrape Data"), not a background job.

## Capabilities and Constraints

Confirmed capabilities today:

- Auth: username/password login, JWT in an HTTP-only cookie, logout. The backend also carries signup, captcha, one-time-password, and password-strength services; these exist but serve a closed invite group rather than open registration.
- Tabs: create, edit, delete, list; title + plain-text content; per-user ownership.
- Song metadata: search Genius from the tab form, attach a song (title, artist, album, thumbnail, lyrics URL, raw metadata JSON); bulk-match existing tabs via the scrape action.
- Lists: create and delete named lists, add/remove tabs, built-in "Favorites"; lists surface in the nav.
- Search: client-side, case-insensitive substring match on tab title only, driven from the nav search field.
- Reading: auto-scroll toggle that scrolls the page at a fixed rate; lyrics link when metadata exists.

Constraints:

- **Tab content is whitespace-significant ASCII.** Column alignment in the tab body must survive every styling decision — monospace, no reflow, no proportional substitution, no wrapping that shifts a fret number off its string. This is the app's hardest rule.
- **Vue 3 (Vite, `<script setup>`, vue-router) is binding.** The CSS library is not: Pico CSS is the incumbent and may be replaced or dropped by future design work.
- Backend is ColdBox on Lucee with SQLite; the UI talks to it over `/api/*`.
- Small data scale — a personal library, not a catalog. No pagination, virtualization, or search-ranking machinery is warranted.

Explicitly undecided / not yet established:

- Whether auto-scroll speed should be user-adjustable.
- Whether search should cover artist, album, or tab content in addition to title.
- Whether tab content ever needs transposition, chord parsing, or capo handling.
- How new members are actually invited (the mechanism is not yet a designed flow).

## Brand Commitments

- Name: **Guitar Tabs**.
- Dark identity is deliberate and binding: near-black surfaces with a lime accent (`#d0eb55`). Future work keeps this, and no light theme is implied.
- Existing asset: `ui/src/assets/favicon.ico` (also `ui/public/favicon.ico`).
- Bootstrap Icons is the incumbent icon set.
- No wordmark, logotype, illustration, photography, or written voice guide exists yet. Do not invent one and present it as established.

## Evidence on Hand

- Real seed data: `backend/resources/database/seeds/tabs.json` and its seeder — usable for realistic titles and content in any mock or screenshot.
- Real Genius API response shape: `backend/resources/schemas/genius_metadata_example.json`.
- Song artwork comes from Genius thumbnail URLs at runtime; it is external and may be absent for any tab (the UI already falls back to a music-note icon).
- No testimonials, customers, usage numbers, press, case studies, pricing, or licensing claims exist. None may be fabricated.

## Product Principles

1. **The tab is the product.** On the playing screen, content legibility outranks every other consideration; chrome recedes when the player is reading.
2. **Alignment is inviolable.** No visual decision may distort the monospaced grid of the tab body.
3. **Designed for arm's length and busy hands.** Type size, contrast, and touch targets are set by a device on a stand, not by a mouse at a desk.
4. **A trusted set, not a catalog.** Organization serves a library small enough to know by heart; favor directness over search machinery and progressive disclosure.
5. **Closed and personal.** No acquisition surfaces, upsell, or public-product theater — every screen serves someone already logged in.

## Accessibility & Inclusion

No user-specific requirement or formal standard has been established. The stand-distance reading scene makes legible type sizes, strong contrast against the dark ground, and generous touch targets a product requirement regardless.
