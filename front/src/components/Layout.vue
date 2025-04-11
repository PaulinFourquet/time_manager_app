<template>
    <div>
      <div v-if="showLayout" :class="themeClasses">
        <NavBar />
        <div class="flex">
          <Sidebar />
          <router-view />
        </div>
      </div>
      <router-view v-else />
    </div>
</template>
  
<script>
  import { useTheme } from '@/composables/useTheme'
  import Sidebar from '@/components/SideBar.vue'
  import NavBar from '@/components/NavBar.vue'
  import { computed } from 'vue'
  import { useRoute } from 'vue-router'
  
  export default {
    components: {
      Sidebar,
      NavBar
    },
    setup() {
      const { themeClasses } = useTheme()
      const route = useRoute()
      const showLayout = computed(() => {
        return !['/login', '/register'].includes(route.path)
      })
  
      return {
        themeClasses,
        showLayout
      }
    }
  }
</script>