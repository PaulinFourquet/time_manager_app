import { createRouter, createWebHistory } from 'vue-router'
import Login from '../views/Login.vue'
import Register from '../views/Register.vue'
import store from '@/store'

const routes = [
  {
    path: '/',
    name: 'Root',
    redirect: to => {
      if (store.state.auth.isAuthenticated) {
        return '/dashboard'
      } else {
        return '/login'
      }
    }
  },
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: () => import('../views/Dashboard.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  {
    path: '/register',
    name: 'Register',
    component: Register
  },
  {
    path: '/users',
    name: 'Users',
    component: () => import('../views/User.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/clocks',
    name: 'Clocks',
    component: () => import('../views/Clock.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/working-times',
    name: 'WorkingTime',
    component: () => import('../views/WorkingTime.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/charts',
    name: 'Charts',
    component: () => import('../views/Chart.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/roles',
    name: 'Roles',
    component: () => import('../views/Role.vue'),
    meta: { requiresAuth: true, requiresSuperAdmin: true }
  },
  {
    path: '/:pathMatch(.*)*',
    redirect: to => {
      return store.state.auth.isAuthenticated ? '/dashboard' : '/login'
    }
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

router.beforeEach(async (to, from, next) => {
  if (to.path === '/') {
    try {
      await store.dispatch('auth/checkAuth')
    } catch (error) {
      console.error("Erreur lors de la vérification de l'authentification:", error)
    }
  }

  const isAuthenticated = store.state.auth.isAuthenticated

  if (to.matched.some(record => record.meta.requiresAuth)) {
    if (!isAuthenticated) {
      next({
        path: '/login',
        query: { redirect: to.fullPath }
      })
    } else {
      if (!store.state.auth.userRole) {
        try {
          await store.dispatch('fetchUserRole')
        } catch (error) {
          console.error("Erreur lors de la récupération du rôle de l'utilisateur:", error)
          next('/login')
          return
        }
      }

      const userRole = store.state.auth.userRole

      if (to.matched.some(record => record.meta.requiresAdmin) && userRole === 'user') {
        next({ path: '/dashboard' })
      } else if (to.matched.some(record => record.meta.requiresSuperAdmin) && userRole !== 'super_admin') {
        next({ path: '/dashboard' })
      } else {
        next()
      }
    }
  } else if (to.path === '/login' && isAuthenticated) {
    next({ path: '/dashboard' })
  } else {
    next()
  }
})

export default router