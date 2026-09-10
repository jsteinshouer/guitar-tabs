<script setup>
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import store from '../store'

const router = useRouter()
const route = useRoute()

const username = ref( '' )
const password = ref( '' )
const error = ref( '' )
const ready = ref( false )
const busy = ref( false )
const returnURL = route.query.returnURL || '/'

onMounted( async () => {
    try {
        await store.checkAuth()
    }
    catch ( e ) { /* an unreachable server is handled on submit */ }

    if ( store.state.isLoggedIn ) router.push( { path: returnURL } )
    else ready.value = true
} )

async function login() {
    if ( busy.value ) return
    if ( !username.value || !password.value ) {
        error.value = 'Both a username and a password are needed to sign in.'
        return
    }

    busy.value = true
    error.value = ''
    try {
        await store.authenticate( username.value, password.value )
        if ( store.state.isLoggedIn ) {
            password.value = ''
            router.push( { path: returnURL } )
        }
        else {
            error.value = 'That username and password did not match. Try again.'
        }
    }
    catch ( e ) {
        error.value = 'The server could not be reached. Check that it is running, then try again.'
    }
    finally {
        busy.value = false
    }
}
</script>

<template>
<div class="page gate" v-if="ready">
    <h1>Guitar Tabs</h1>
    <p class="prose lead">Sign in to reach your library.</p>

    <!-- A real form, so Enter submits instead of reloading the page. -->
    <form @submit.prevent="login">
        <label class="field">
            <span class="label">username</span>
            <input type="text" name="login" autocomplete="username" v-model="username" :disabled="busy">
        </label>

        <label class="field">
            <span class="label">password</span>
            <input type="password" name="password" autocomplete="current-password" v-model="password" :disabled="busy">
        </label>

        <p class="alarm-text" v-if="error">{{ error }}</p>

        <button type="submit" class="legend primary sign" :class="{ working: busy }" :disabled="busy">
            {{ busy ? '[ SIGNING IN ]' : '[ SIGN IN ]' }}
        </button>
    </form>
</div>

<div class="page gate" v-else>
    <p class="prose">Checking your session&hellip;</p>
</div>
</template>

<style scoped>
.gate {
    max-width: 26rem;
    padding-top: 3rem;
}

.lead { margin: 0.5rem 0 2rem; }
.sign { padding-left: 0; margin-top: 0.4rem; }
.alarm-text { margin-bottom: 0.6rem; }
</style>
