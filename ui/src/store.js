import { reactive } from 'vue';
import { fetchHelper } from "./helpers/fetchHelper.js";

let state = reactive({
    isLoggedIn: false,
    myTabs: []
});

function isLoggedIn() {
    return state.isLoggedIn;
}

async function authenticate( username, password ) {
    
    const authResponse = await fetchHelper.post("/api/authorize", {
        username: username,
        password: password
    });

    if ( authResponse.statusCode == 200 ) {
        state.isLoggedIn = true;
        await loadTabs()
    }
    else {
        state.isLoggedIn = false;
    }

    return authResponse;
}

async function checkAuth() {
    
    const response = await fetchHelper.get("/api/echo");

    if ( response.statusCode == 200 ) {
        state.isLoggedIn = true;
        await loadTabs()
    }
    else {
        state.isLoggedIn = false;
    }

}

async function loadTabs() {
    const dataResponse = await fetchHelper.get("/api/tablature");
    state.myTabs = dataResponse.data;
}


export default {
    state,
    authenticate,
    checkAuth,
    isLoggedIn,
    loadTabs
};