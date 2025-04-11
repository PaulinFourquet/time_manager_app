import { ref, computed, watch } from 'vue'

const isDarkTheme = ref(false)

const toggleTheme = () => {
  isDarkTheme.value = !isDarkTheme.value
}

const NavBar = computed(() => isDarkTheme.value ? 'bg-bgButtonGray text-LightGray' : 'bg-[#d0e3e9] text-black')
const themeClasses = computed(() => isDarkTheme.value ? 'bg-Black text-LightGray' : 'bg-whiteBg text-black')
const linkClasses = (current) => computed(() => current ? 'text-white bg-gray-900' : 'text-black hover:bg-gray-700 hover:text-white')

watch(isDarkTheme, (newValue) => {
  document.body.className = newValue ? 'bg-Black text-LightGray' : 'bg-whiteBg text-black'
})

export function useTheme() {
  return {
    NavBar,
    isDarkTheme,
    toggleTheme,
    themeClasses,
    linkClasses
  }
}