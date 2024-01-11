<script setup>
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import store from '../store'
const router = useRouter()
const route = useRoute()

// let tab = store.state.myTabs.find( (item) => item.id == route.params.id );
const username = ref('')
const password = ref('')
const errorMessage = ref('')
const showLogin = ref(false)
const busy = ref(false)
const returnURL = route.query.returnURL || "/"

onMounted( async () => {
  //Check the server to see if it not a browser reload
	await store.checkAuth()
	if ( store.state.isLoggedIn ) {
		router.push( { path: returnURL })
	}
	else {
		showLogin.value = true;
	}
})
async function login() {
	if ( username.value && password.value ) {
		busy.value = true;
		await store.authenticate( username.value, password.value )
		if ( !store.state.isLoggedIn ) {
			busy.value = false;
			errorMessage.value = "Login failed!"
		}
		else {
			password.value = '';
			router.push( { path: returnURL })
		}
	}
	else {
		errorMessage.value = "Username and password are required!"
	}

}
</script>

<template>
		<div>
			<article v-if="showLogin">
			<hgroup>
				<h1>Sign in</h1>
				<h2></h2>
			</hgroup>
			<form>
				<input
					type="text"
					name="login"
					placeholder="Login"
					aria-label="Login"
					required
					v-model="username"
				/>
				<input
					type="password"
					name="password"
					placeholder="Password"
					aria-label="Password"
					autocomplete="current-password"
					required
					v-model="password"
				/>
				<!-- <fieldset>
				<label for="remember">
					<input type="checkbox" role="switch" id="remember" name="remember" />
					Remember me
				</label>
				</fieldset> -->
				<button type="submit" class="contrast" @click.prevent="login" :aria-busy="busy" :disabled="busy"> Login</button>
				<span class="error">{{ errorMessage }}</span>
			</form>
		</article>
	</div>
</template>

<style scoped>
	article {
	max-width: 600px;
		width: 90%;
		margin: 0 auto;
		padding: 20px;
	}
</style>