<template>
  <div>
    <div :class="[isDarkTheme ? 'bg-InputBgGray text-white shadow-none' : 'bg-white text-black', 'w-full p-8 mt-4 h-max rounded-3xl shadow-lg shadow-gray-400/90']">
      <h1 class="text-2xl font-medium text-center mb-4 font-poppins">Clock Manager</h1>
      
      <div v-if="userRole !== 'user'" class="mb-4">
        <label for="userid" :class="[isDarkTheme ? 'text-gray-300' : 'text-gray-600', 'block text-xs font-medium font-poppins']">User Id</label>
        <input type="text" id="user-id" placeholder="Enter User Id" @input="onUserIdInput" v-model="inputUserId"
          :class="[isDarkTheme ? 'bg-InputBgGray border-LightGray text-white' : 'border-bluePurple placeholder-gray-300 text-black', 'mt-1 block w-full px-4 py-2 border rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-bluePurple focus:border-transparent']">
        <button @click="setUserId" :disabled="!inputUserId" class="mt-2 px-4 py-2 bg-bluePurple text-white rounded-lg">Set User</button>
      </div>

      <div class="mt-2 flex justify-center">
        <button 
          @click="clock" 
          :disabled="isLoading || !currentUserId" 
          :class="[isDarkTheme ? 'shadow-none shadow-gray-400/90 transition-colors px-6 py-2 text-white bg-bluePurple rounded-lg hover:bg-bluePurpleHover focus:outline-none focus:ring-2 focus:ring-bluePurple focus:ring-opacity-50' : 'shadow-lg shadow-gray-400/90 transition-colors px-6 py-2 text-white bg-bluePurple rounded-lg hover:bg-bluePurpleHover focus:outline-none focus:ring-2 focus:ring-bluePurple focus:ring-opacity-50']">        
          {{ isClockingIn ? 'Clock In' : 'Clock Out' }}
        </button>
      </div>

      <div class="mt-4 text-sm text-center" :class="[isDarkTheme ? 'text-gray-300' : 'text-gray-500']">
        <p>{{ statusMessage }}</p>
      </div>

      <div v-if="errorMessage" class="mt-2 text-sm text-red-500 text-center">
        {{ errorMessage }}
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed, onMounted } from 'vue'
import { useStore } from 'vuex'
import api from '@/services/api'
import { useTheme } from '@/composables/useTheme'

export default {
  name: 'ClockManager',
  setup() {
    const store = useStore()
    const { isDarkTheme } = useTheme()
    
    const userRole = computed(() => store.state.auth.userRole)
    const loggedInUserId = computed(() => store.state.auth.userId)
    
    const inputUserId = ref('')
    const currentUserId = ref(null)
    const isClockingIn = ref(true)
    const isLoading = ref(false)
    const lastClockTime = ref(null)
    const statusMessage = ref('Not currently working')
    const errorMessage = ref('')

    const onUserIdInput = (event) => {
      inputUserId.value = event.target.value.replace(/[^0-9]/g, '')
    }

    const setUserId = () => {
      if (inputUserId.value) {
        currentUserId.value = inputUserId.value
        resetClockState()
        refresh()
      }
    }

    const clock = async () => {
      isLoading.value = true
      errorMessage.value = ''
      try {
        const currentTime = new Date().toISOString()
        const status = isClockingIn.value
        await api.postClock(currentUserId.value, currentTime, status)
        isClockingIn.value = !isClockingIn.value
        lastClockTime.value = new Date(currentTime)
        updateStatusMessage()
      } catch (error) {
        console.error('Error clocking in/out:', error)
        errorMessage.value = 'Error clocking in/out. Please try again.'
      } finally {
        isLoading.value = false
      }
    }

    const updateStatusMessage = () => {
      if (isClockingIn.value) {
        statusMessage.value = lastClockTime.value 
          ? `Last clocked out at: ${formatDateTime(lastClockTime.value)}` 
          : 'Not currently working'
      } else {
        statusMessage.value = `Currently working since: ${formatDateTime(lastClockTime.value)}`
      }
    }

    const formatDateTime = (dateTime) => {
      return dateTime.toLocaleString()
    }

    const resetClockState = () => {
      isClockingIn.value = true
      lastClockTime.value = null
      statusMessage.value = 'Not currently working'
    }

    const refresh = async () => {
      if (!currentUserId.value) return

      try {
        const response = await api.getClocks(currentUserId.value)
        if (response.data && response.data.length > 0) {
          const lastClock = response.data[response.data.length - 1]
          isClockingIn.value = lastClock.status === "false"
          lastClockTime.value = new Date(lastClock.time)
          updateStatusMessage()
        } else {
          resetClockState()
        }
      } catch (error) {
        console.error('Error refreshing clock status:', error)
        resetClockState()
      }
    }

    onMounted(() => {
      if (userRole.value === 'user') {
        currentUserId.value = loggedInUserId.value
        refresh()
      }
    })

    return {
      isDarkTheme,
      userRole,
      inputUserId,
      currentUserId,
      isClockingIn,
      isLoading,
      statusMessage,
      errorMessage,
      onUserIdInput,
      setUserId,
      clock
    }
  }
}
</script>