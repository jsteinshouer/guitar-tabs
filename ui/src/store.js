import { reactive } from 'vue';
import { fetchHelper } from "./helpers/fetchHelper.js";

let state = reactive({
    isLoggedIn: false,
    myTabs: [],
    lists: [],
    searchQuery: ""
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
        await loadLists()
    }
    else {
        state.isLoggedIn = false;
    }

    return authResponse;
}

async function logout() {
    const authResponse = await fetchHelper.get("/api/authorize/logout");
    state.isLoggedIn = false;
}

async function checkAuth() {
    
    const response = await fetchHelper.get("/api/echo");

    if ( response.statusCode == 200 ) {
        state.isLoggedIn = true;
        await loadTabs()
        await loadLists()
    }
    else {
        state.isLoggedIn = false;
    }

}

async function loadTabs() {
    const dataResponse = await fetchHelper.get("/api/tablature");
    state.myTabs = dataResponse.data;
}

async function addTab( tab ) {
    const response = await fetchHelper.post("/api/tablature", tab );

    if ( response.statusCode == 201 ) {
        await loadTabs()
    }
    
}

async function updateTab( tab ) {
    const response = await fetchHelper.put(`/api/tablature/${tab.id}`, tab );
}
async function deleteTab( tab ) {
    const response = await fetchHelper.delete(`/api/tablature/${tab.id}` );

    if ( response.statusCode == 200 ) {
        await loadTabs()
    }
}

async function scrapeMetadata( tab ) {
    const response = await fetchHelper.get("/api/genius/scrape" );
    state.myTabs = response.data;
}

function getFavoriteslist() {
    let favoritesList = state.lists.find((element) => element.title == "Favorites")
    if ( !favoritesList ) {
        favoritesList = createFavoritesList()
    }
    return favoritesList;
}

async function createList( title ) {
    const response = await fetchHelper.post("/api/list", {
        title: title
    });

    state.lists.push( response.data );

    return response.data;
}
async function createFavoritesList() {

    return createList("Favorites");
}

async function addListItem( listID, tabID ) {
    const response = await fetchHelper.post( `/api/list/${listID}/item/${tabID}`, {})

    loadLists();

    return response.data;
}
async function removeListItem( listID, tabID ) {
    const response = await fetchHelper.delete( `/api/list/${listID}/item/${tabID}`)

    loadLists();

    return response.data;
}
async function deleteList( listID ) {
    const response = await fetchHelper.delete( `/api/list/${listID}`)

    loadLists();

    return response.data;
}

async function loadLists() {
    const response = await fetchHelper.get( '/api/list' );
    state.lists = response.data;
}


export default {
    state,
    authenticate,
    logout,
    checkAuth,
    isLoggedIn,
    loadTabs,
    addTab,
    deleteTab,
    updateTab,
    scrapeMetadata,
    getFavoriteslist,
    addListItem,
    removeListItem,
    createList,
    deleteList
};