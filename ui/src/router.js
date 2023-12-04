import { createRouter, createWebHistory } from 'vue-router'
import store from './store'
import MyTabs from './views/MyTabs.vue'
import Tab from './views/Tab.vue' 
import Login from './views/Login.vue'
import TabEdit from './views/TabEdit.vue'

const routes = [
    {
        path: '/',
        component: MyTabs,
        meta: { requiredAuth: true }
    },
    {
        path: '/login',
        component: Login,
        meta: { requiredAuth: false }
    },
    {
        path: '/tab/:id',
        component: Tab,
        meta: { requiredAuth: true }
    },
    {
        path: '/edit/:id',
        component: TabEdit,
        meta: { requiredAuth: true }
    } 
]

const router = createRouter({
    // 4. Provide the history implementation to use. We are using the hash history for simplicity here.
    history: createWebHistory(),
    routes, // short for `routes: routes`
    scrollBehavior(to, from, savedPosition) {
        // always scroll to top
        return { top: 0 }
    }
})

router.beforeEach((to, from, next ) => {
    if (to.meta.requiredAuth && !store.state.isLoggedIn ) {
        return next({ path: "/login" });
    }
    else {
        return next();
    }
    // explicitly return false to cancel the navigation
    return false
})

export default router