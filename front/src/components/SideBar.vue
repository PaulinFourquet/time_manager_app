<template>
  <aside :class="['w-64 hidden sm:block', isDarkTheme ? 'bg-buttonBgGray' : 'bg-whiteBg']">
    <nav class="flex flex-col items-start mt-10 space-y-2 px-8 sticky top-0">
      <a
        v-for="item in filteredNavigation"
        :key="item.name"
        :href="item.href"
        :class="[
          'flex  items-center text-[15px] font-semibold hover:text-bluePurple border-b py-2 w-full', 
          linkClasses(item.href), 
          isDarkTheme ? 'text-white' : 'text-white'
        ]"
        :aria-current="item.current ? 'page' : undefined"
      >
        <component :is="item.icon" class="mr-2 h-5 w-5" />
        {{ item.name }}
      </a>
    </nav>
  </aside>
</template>

<script setup>
import { computed } from 'vue'
import { useStore } from 'vuex'
import { useTheme } from '@/composables/useTheme'
import { useRoute } from 'vue-router'

import { UserIcon, ClockIcon, BriefcaseIcon, ChartPieIcon, LockClosedIcon } from '@heroicons/vue/24/outline'

const navigation = [
  { name: 'User', href: '/users', icon: UserIcon, roles: ['admin', 'super_admin'] },
  { name: 'Clock', href: '/clocks', icon: ClockIcon, roles: ['user', 'admin', 'super_admin'] },
  { name: 'Working Time', href: '/working-times', icon: BriefcaseIcon, roles: ['user', 'admin', 'super_admin'] },
  { name: 'Chart', href: '/charts', icon: ChartPieIcon, roles: ['admin', 'super_admin'] },
  { name: 'Role', href: '/roles', icon: LockClosedIcon, roles: ['super_admin'] },
]

const store = useStore()
const { isDarkTheme } = useTheme()
const userRole = computed(() => store.state.auth.userRole)

const filteredNavigation = computed(() => {
  return navigation.filter(item => item.roles.includes(userRole.value))
})

const route = useRoute()

const linkClasses = (href) => {
  return route.path === href ? 'flex justify-center items-center text-bluePurple font-bold bg-black rounded-full py-4 hover:bg-gray-200' : '';
}
</script>