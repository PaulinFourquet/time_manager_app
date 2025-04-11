<template>
<div class="min-h-screen w-full bg-cover bg-center bg-fixed shadow-sm border-t-[0.1%] border-l-[0.1%] border-[#000000] rounded-tl-[2%] pl-[0.5%] pr-[0.5%] xl:pl-[0.9%] xl:pr-[0.9%]" :style="{ backgroundImage: 'url(/src/assets/bg-dashboard.jpeg)' }">
    <div class="h-full xl:ml-4">
      <div class="flex flex-col space-y-8 w-full h-full">
        <div class="flex items-start h-full mt-6">
          <div class="flex flex-col items-center mr-4 w-8 h-full">
            <span class="text-bluePurple text-4xl mb-1 flex-shrink-0">●</span>
            <div class="w-px bg-white flex-grow"></div>
          </div>
          <div class="flex-grow">
            <h1 :class="['text-2xl font-poppins font-medium', isDarkTheme ? 'text-white' : 'text-white']">List</h1>
            <UserTable />
          </div>
        </div>
        <div v-if="isUser" class="flex items-start h-full">
          <div class="flex flex-col items-center mr-4 w-8 h-full">
            <span class="text-bluePurple text-4xl mb-1 flex-shrink-0">●</span>
            <div class="w-px bg-white flex-grow"></div>
          </div>
          <div class="flex-grow">
            <h1 :class="['text-2xl font-poppins font-medium', isDarkTheme ? 'text-white' : 'text-white']">Create</h1>
            <UserFormCreate />
          </div>
        </div>
      </div>
    </div>
</div>
</template>
  
<script>
  import { computed } from 'vue'
  import { useStore } from 'vuex'
  import { useTheme } from '@/composables/useTheme'
  import UserTable from '../components/User/UserTable.vue';
  import UserFormCreate from '../components/User/UserFormCreate.vue';
  
  export default {
    name: 'Home',
    components: {
      UserTable,
      UserFormCreate,
    },
    setup() {
      const store = useStore()
      const { isDarkTheme } = useTheme()
      const userRole = computed(() => store.state.auth.userRole)

      const isSuperAdmin = computed(() => userRole.value !== 'super_admin')
      const isAdmin = computed(() => userRole.value !== 'admin')
      const isUser = computed(() => userRole.value !== 'user')

      const userId = computed(() => store.state.auth.userId)
  
      return {
        isSuperAdmin,
        isAdmin,
        isUser,
        isDarkTheme,
        userRole,
        userId
      }
    }
  }
</script>