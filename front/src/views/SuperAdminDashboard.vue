<template>
  <div
    class="min-h-screen w-full bg-cover bg-center bg-fixed shadow-sm border-t-[0.1%] border-l-[0.1%] border-[#000000] rounded-tl-[2%] pl-[0.5%] pr-[0.5%] xl:pl-[0.9%] xl:pr-[0.9%]"
    :style="{ backgroundImage: 'url(/src/assets/bg-dashboard.jpeg)' }"
  >
    <div class="flex flex-col items-start space-y-8 h-full">
      <div
        :class="[
          'ml-8 mt-8 p-4 w-2/3 sm:w-1/2 lg:w-1/4 xl:w-1/5 rounded-lg shadow-md',
          isDarkTheme ? 'bg-InputBgGray text-white' : 'bg-white text-black'
        ]"
      >
        <h2 class="text-bluePurple font-bold text-2xl sm:text-3xl font-poppins">Today</h2>
        <DateComponent class="font-poppins sm:text-xl font-semibold pt-2 sm:pt-3" />
      </div>

      <div class="flex flex-col space-y-8 w-full h-full">
        <div class="flex items-start h-full">
          <div class="flex flex-col items-center mr-4 w-8 h-full">
            <span class="text-bluePurple text-4xl mb-1 flex-shrink-0">●</span>
            <div class="w-px bg-white flex-grow"></div>
          </div>
          <div class="flex-grow">
            <h1
              :class="[
                'text-2xl font-poppins font-medium',
                isDarkTheme ? 'text-white' : 'text-black'
              ]"
            >
              User
            </h1>
            <User />
          </div>
        </div>

        <div class="flex items-start h-full">
          <div class="flex flex-col items-center mr-4 w-8 h-full">
            <span class="text-bluePurple text-4xl mb-1 flex-shrink-0">●</span>
            <div class="w-px bg-white flex-grow"></div>
          </div>
          <div class="flex-grow">
            <h1
              :class="[
                'text-2xl font-poppins font-medium',
                isDarkTheme ? 'text-white' : 'text-black'
              ]"
            >
              Roles
            </h1>
            <Roles />
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
import DateComponent from '@/components/DateComponent.vue'
import User from '@/components/User/User.vue'
import Clock from '@/components/Clock/Clock.vue'
import WorkingTimes from '@/components/WorkingTime/WorkingTimeManager.vue'
import ChartManager from '@/components/Clock/ChartManager.vue'
import Roles from '@/components/Roles.vue'
import bgImage from '@/assets/bg-dashboard.jpeg'

export default {
  name: 'SuperAdminDashboard',
  components: {
    DateComponent,
    User,
    Clock,
    WorkingTimes,
    ChartManager,
    Roles
  },
  setup() {
    const store = useStore()
    const { isDarkTheme } = useTheme()
    const userRole = computed(() => store.state.auth.userRole)

    const isSuperAdmin = computed(() => userRole.value === 'super_admin')
    const isAdmin = computed(() => userRole.value === 'admin')
    const isUser = computed(() => userRole.value === 'user')

    return {
      isSuperAdmin,
      isAdmin,
      isUser,
      isDarkTheme,
      backgroundImage: `url(${bgImage})`
    }
  }
}
</script>
