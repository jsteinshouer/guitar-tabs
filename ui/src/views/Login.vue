<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import store from '../store'
const router = useRouter()

// let tab = store.state.myTabs.find( (item) => item.id == route.params.id );
const username = ref('')
const password = ref('')
const errorMessage = ref('')
const showLogin = ref(false)

onMounted( async () => {
  //Check the server to see if it not a browser reload
	await store.checkAuth()
	if ( store.state.isLoggedIn ) {
		router.push( { path: "/" })
	}
	else {
		showLogin.value = true;
	}
})
async function login() {
	if ( username.value && password.value ) {
		await store.authenticate( username.value, password.value )
		if ( !store.state.isLoggedIn ) {
			errorMessage.value = "Login failed!"
		}
		else {
			router.push( { path: "/" })
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
					autocomplete="nickname"
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
				<button type="submit" class="contrast" @click.prevent="login">Login</button>
				<span class="error">{{ errorMessage }}</span>
			</form>
		</article>
	</div>
</template>

<style scoped>
	article {
		width: 70%;
		margin-left: 15%;
		padding: 20px;
	}
</style>