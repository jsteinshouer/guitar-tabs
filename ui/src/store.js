import { reactive } from 'vue';
import { fetchHelper } from "./helpers/fetchHelper.js";

let state = reactive({
    isLoggedIn: false,
    myTabs: []
});

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

async function loadTabs() {
    const dataResponse = await fetchHelper.get("/api/tablature");
    state.myTabs = dataResponse.data;
}


export default {
    state,
    authenticate,
    loadTabs
};