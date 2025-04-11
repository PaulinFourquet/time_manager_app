import { createStore } from 'vuex'
import api from '@/services/api'
import { jwtDecode } from 'jwt-decode'
import router from '@/router'

export default createStore({
  state: {
    auth: {
      isAuthenticated: false,
      userRole: null,
      userId: null
    }
  },
  actions: {
    async login({ dispatch }, { email, password }) {
      try {
        const response = await api.login(email, password);
        await dispatch('setUserData', response.data.data.token);
        router.push('/dashboard');
        return true;
      } catch (error) {
        console.error("Erreur de connexion:", error);
        return false;
      }
    },
    async setUserData({ commit, dispatch }, token) {
      if (typeof token !== 'string' || token.trim() === '') {
        console.error("Invalid token received");
        dispatch('logout');
        return;
      }
      try {
        const decodedToken = jwtDecode(token);
        commit('setAuth', { 
          isAuthenticated: true, 
          userId: decodedToken.sub
        });
        localStorage.setItem('token', token);
        await dispatch('fetchUserRole');
      } catch (error) {
        console.error("Error decoding token:", error);
        dispatch('logout');
      }
    },
    async fetchUserRole({ commit, state }) {
      try {
        const userRoleResponse = await api.getUserRoles(state.auth.userId);
        const userRoleData = userRoleResponse.data.data[0];
    
        if (userRoleData) {
          commit('SET_USER_ROLE', userRoleData.role_name);
        } else {
          console.error("User role not found");
        }
      } catch (error) {
        console.error("Erreur lors de la récupération du rôle de l'utilisateur:", error);
      }
    },
    logout({ commit }) {
      localStorage.removeItem('token');
      commit('setAuth', { 
        isAuthenticated: false, 
        userRole: null,
        userId: null
      });
    },
    checkAuth({ dispatch }) {
      const token = localStorage.getItem('token');
      if (token) {
        try {
          const decodedToken = jwtDecode(token);
          const currentTime = Date.now() / 1000;
          if (decodedToken.exp > currentTime) {
            dispatch('setUserData', token);
            return true;
          } else {
            dispatch('logout');
          }
        } catch (error) {
          console.error("Erreur lors de la vérification du token:", error);
          dispatch('logout');
        }
      }
      return false;
    }
  },
  mutations: {
    setAuth(state, { isAuthenticated, userId }) {
      state.auth.isAuthenticated = isAuthenticated;
      state.auth.userId = Number(userId);
    },
    SET_USER_ROLE(state, role) {
      state.auth.userRole = role;
    }
  },
  getters: {
    isAuthenticated: state => state.auth.isAuthenticated,
    userRole: state => state.auth.userRole,
    userId: state => state.auth.userId
  }
})