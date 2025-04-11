<template>
  <Disclosure as="nav" v-slot="{ open }">
    <div :class="NavBar" class="bg-[#d0e3e9]">
      <div class="relative flex h-20 items-center justify-between">
        <div class="absolute inset-y-0 left-0 flex items-center sm:hidden">
          <DisclosureButton
            :class="[
              isDarkTheme ? 'text-white' : 'text-black',
              'relative inline-flex items-center justify-center rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white'
            ]"
          >
            <span class="sr-only">Open main menu</span>
            <Bars3Icon
              v-if="!open"
              :class="[isDarkTheme ? 'text-white' : 'text-black', 'block h-6 w-6']"
              aria-hidden="true"
            />
            <XMarkIcon
              v-else
              :class="[isDarkTheme ? 'text-white' : 'text-black', 'block h-6 w-6']"
              aria-hidden="true"
            />
          </DisclosureButton>
        </div>

        <div
          class="xl:ml-9 flex flex-1 items-center justify-center sm:items-stretch sm:justify-between"
        >
          <div class="hidden sm:flex items-center">
            <router-link to="/"  :class="[isDarkTheme ? 'text-white' : 'text-black','text-3xl font-bangers cursor-pointer']"> GOTHAM TIME MANAGER </router-link>
          </div>

          <div class="flex items-center">
            <img
              :class="[isDarkTheme ? 'h-10 w-auto' : 'h-14 w-auto', 'cursor-pointer']"
              :src="currentIcon"
              alt="Gotham Bat Signal"
            />
          </div>

          <div
            class="xl:mr-9 absolute inset-y-0 right-0 flex items-center pr-2 sm:static sm:inset-auto sm:ml-6 sm:pr-0"
          >
            <Menu as="div" class="relative ml-3">
              <div class="flex justify-between items-center">
                <div class="flex items-center mr-6">
                  <button
                    @click="toggleTheme"
                    class="relative inline-flex items-center h-8 w-16 rounded-full transition-colors duration-300"
                    :class="isDarkTheme ? 'bg-blue-600' : 'bg-gray-300'"
                  >
                    <span class="sr-only">Toggle Dark Mode</span>
                    <span
                      class="absolute left-1 w-6 h-6 rounded-full bg-white shadow transform transition-transform duration-300"
                      :class="isDarkTheme ? 'translate-x-8' : ''"
                    ></span>
                    <SunIcon
                      class="absolute left-1.5 h-5 w-5 text-yellow-500"
                      v-if="!isDarkTheme"
                    />
                    <MoonIcon class="absolute right-1.5 h-5 w-5 text-gray-400" v-else />
                  </button>
                </div>
                <div class="hidden sm:block text-base font-semibold mr-4">
                  {{ username }}
                </div>
                <MenuButton
                  class="relative flex rounded-full focus:ring-4 focus:ring-bluePurple hover:ring-4 hover:ring-bluePurple"
                >
                  <div
                    v-if="username"
                    class="flex items-center justify-center h-10 w-10 rounded-full bg-blue-500 text-white font-bold"
                  >
                    {{ getInitials(username) }}
                  </div>
                  <img
                    v-else
                    class="h-10 w-10 rounded-full"
                    src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                    alt=""
                  />
                </MenuButton>
              </div>
              <transition
                enter-active-class="transition ease-out duration-100"
                enter-from-class="transform opacity-0 scale-95"
                enter-to-class="transform opacity-100 scale-100"
                leave-active-class="transition ease-in duration-75"
                leave-from-class="transform opacity-100 scale-100"
                leave-to-class="transform opacity-0 scale-95"
              >
                <MenuItems
                  :class="[
                    isDarkTheme ? 'bg-InputBgGray' : 'bg-white',
                    'absolute right-0 z-10 mt-2 w-48 origin-top-right rounded-md py-1 shadow-lg ring-1 ring-opacity-5 focus:outline-none'
                  ]"
                >
                  <MenuItem v-slot="{ active }">
                    <a
                      href="#"
                      @click.prevent="logout"
                      :class="[
                        active ? 'bg-gray-100' : '',
                        'block px-4 py-2 text-sm',
                        isDarkTheme ? 'text-LightGray' : 'text-gray-900'
                      ]"
                    >
                      Sign out
                    </a>
                  </MenuItem>
                </MenuItems>
              </transition>
            </Menu>
          </div>
        </div>
      </div>
    </div>

    <DisclosurePanel class="sm:hidden">
      <div class="space-y-1 px-2 pb-3 pt-2">
        <DisclosureButton
          v-for="item in navigation"
          :key="item.name"
          as="a"
          :href="item.href"
          @click.prevent="scrollToSection(item.href)"
          :class="[
            'flex items-center text-xl font-bangers font-semibold hover:text-bluePurple border-b py-2',
            linkClasses(item.current),
            isDarkTheme ? 'text-white' : 'text-white'
          ]"
          :aria-current="item.current ? 'page' : undefined"
        >
          <span class="flex items-center space-x-2">
            <component :is="item.icon" class="h-5 w-5" />
            <span>{{ item.name }}</span>
          </span>
        </DisclosureButton>
      </div>
    </DisclosurePanel>
  </Disclosure>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { useStore } from 'vuex'
import {
  Disclosure,
  DisclosureButton,
  DisclosurePanel,
  Menu,
  MenuButton,
  MenuItem,
  MenuItems
} from '@headlessui/vue'
import {
  Bars3Icon,
  XMarkIcon,
  SunIcon,
  MoonIcon,
  UserIcon,
  ClockIcon,
  BriefcaseIcon
} from '@heroicons/vue/24/outline'
import BatmanIcon from '@/assets/batman-old.png'
import BatmanIconBlanc from '@/assets/batman-blanc.png'
import { useTheme } from '@/composables/useTheme'
import { useRouter } from 'vue-router'
import api from '@/services/api'

const store = useStore()
const router = useRouter()

const navigation = [
  { name: 'User', href: '/users', icon: UserIcon },
  { name: 'Clock', href: '#clock', icon: ClockIcon },
  { name: 'Working Time', href: '#working-time', icon: BriefcaseIcon }
]

const { isDarkTheme, toggleTheme, NavBar, linkClasses } = useTheme()
const currentIcon = computed(() => (isDarkTheme.value ? BatmanIconBlanc : BatmanIcon))

const userId = computed(() => store.state.auth.userId) 
const username = ref('')


const fetchUsername = async (id) => {
  try {
    const response = await api.listUsers() 
    console.log(response, 'test')

    if (response.data && response.data.data && response.data.data.length > 0) {
      
      const user = response.data.data.find((user) => user.id === id)
      if (user) {
        username.value = user.username 
      } else {
        console.error("Aucun utilisateur trouvé pour l'ID donné")
      }
    } else {
      console.error('Aucun utilisateur trouvé')
    }
  } catch (error) {
    console.error("Erreur lors de la récupération du nom d'utilisateur:", error)
  }
}

onMounted(() => {
  if (userId.value) {
    fetchUsername(userId.value)
  } else {
    console.error('Aucun ID utilisateur disponible')
  }
})

const getInitials = (username) => {
  const nameParts = username.split(' ')
  if (nameParts.length === 1) {
    return nameParts[0].charAt(0).toUpperCase()
  }
  return nameParts[0].charAt(0).toUpperCase() + nameParts[1].charAt(0).toUpperCase()
}

const logout = async () => {
  try {
    await api.logout()
    await store.dispatch('logout')
    router.push('/login')
  } catch (error) {
    console.error('Erreur lors de la déconnexion:', error)
  }
}
</script>
