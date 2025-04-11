<template>
  <component :is="currentRoleView"></component>
</template>
  
  <script>
  import { computed } from 'vue'
  import { useStore } from 'vuex'
  import UserDashboard from './UserDashboard.vue'
  import AdminDashboard from './AdminDashboard.vue'
  import SuperAdminDashboard from './SuperAdminDashboard.vue'
    
  export default {
    setup() {
      const store = useStore()
      const userRole = computed(() => store.state.auth.userRole)
  
      const currentRoleView = computed(() => {
        switch(userRole.value) {
          case 'user':
            return UserDashboard
          case 'admin':
            return AdminDashboard
          case 'super_admin':
            return SuperAdminDashboard
          default:
            return UserDashboard
        }
      })
  
      return { 
        currentRoleView,
      }
    }
  }
  </script>