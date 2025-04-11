<template>
  <div :class="[isDarkTheme ? 'bg-InputBgGray text-white shadow-none' : 'bg-white text-black', 'mt-6 w-full h-auto rounded-3xl shadow-lg shadow-gray-400/90 p-2']">
    <div class="p-4 sm:px-6 lg:px-8 xl:mb-4">
      <h2 class="text-2xl font-medium text-center mb-4 font-poppins">Working Times</h2>

      <div v-if="userRole !== 'user'" class="mb-4">
        <select 
          v-model="selectedUserId" 
          @change="fetchWorkingTimes"
          :class="[isDarkTheme ? 'bg-InputBgGray border-LightGray text-white' : 'border-bluePurple text-black', 'mt-1 block w-full px-4 py-2 border rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-bluePurple focus:border-transparent']"
        >
          <option value="">All Users</option>
          <option v-for="user in users" :key="user.id" :value="user.id">
            {{ user.username }} (ID: {{ user.id }})
          </option>
        </select>
      </div>

      <div class="flow-root">
        <div class="overflow-x-auto">
          <div class="inline-block min-w-full align-middle">
            <table class="min-w-full divide-y" :class="[isDarkTheme ? 'divide-gray-700' : 'divide-gray-300']">
              <thead class="text-left text-sm font-semibold" :class="[isDarkTheme ? 'text-LightGray' : 'text-gray-900']">
                <tr class="pl-4 xl:pl-16 text-left text-sm font-semibold font-poppins">
                  <th scope="col">User ID</th>
                  <th scope="col">Start Time</th>
                  <th scope="col">End Time</th>
                  <th scope="col">Duration</th>
                </tr>
              </thead>
              <tbody :class="[isDarkTheme ? 'divide-gray-700 bg-bgButtonGray' : 'bg-white divide-gray-200']">
                <tr v-for="workingTime in displayedWorkingTimes" :key="workingTime.id" :class="[isDarkTheme ? 'hover:bg-gray-600' : 'hover:bg-gray-50']">
                  <td class="whitespace-nowrap px-3 py-2 text-sm" :class="[isDarkTheme ? 'text-LightGray' : 'text-gray-900']">{{ workingTime.user_id }}</td>
                  <td class="whitespace-nowrap px-3 py-2 text-sm" :class="[isDarkTheme ? 'text-LightGray' : 'text-gray-900']">{{ formatDate(workingTime.start) }}</td>
                  <td class="whitespace-nowrap px-3 py-2 text-sm" :class="[isDarkTheme ? 'text-LightGray' : 'text-gray-900']">{{ formatDate(workingTime.end) }}</td>
                  <td class="whitespace-nowrap px-3 py-2 text-sm" :class="[isDarkTheme ? 'text-LightGray' : 'text-gray-900']">{{ calculateDuration(workingTime.start, workingTime.end) }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>


      <p v-if="displayedWorkingTimes.length === 0" class="text-center mt-4" :class="[isDarkTheme ? 'text-LightGray' : 'text-gray-500']">
        No working times found.
      </p>
    </div>
  </div>
</template>

<script>
import { ref, computed, onMounted } from 'vue'
import { useStore } from 'vuex'
import { useTheme } from '@/composables/useTheme'
import api from '@/services/api'

export default {
  setup() {
    const store = useStore()
    const { isDarkTheme } = useTheme()
    const userRole = computed(() => store.state.auth.userRole)
    const loggedInUserId = computed(() => store.state.auth.userId)

    const selectedUserId = ref('')
    const allWorkingTimes = ref([])
    const users = ref([])

    const displayedWorkingTimes = computed(() => {
      if (userRole.value === 'user') {
        return allWorkingTimes.value.filter(wt => wt.user_id === loggedInUserId.value)
      }
      return selectedUserId.value 
        ? allWorkingTimes.value.filter(wt => wt.user_id === selectedUserId.value)
        : allWorkingTimes.value
    })

    const fetchUsers = async () => {
      try {
        const response = await api.listUsers()
        users.value = response.data.data
      } catch (error) {
        console.error('Error fetching users:', error)
      }
    }

    const fetchWorkingTimes = async () => {
      try {
        if (userRole.value === 'user') {
          const response = await api.getWorkingTimesByUser(loggedInUserId.value)
          allWorkingTimes.value = response.data.data
        } else {
          const response = await api.getWorkingTimes()
          allWorkingTimes.value = response.data.data
        }
      } catch (error) {
        console.error('Error fetching working times:', error)
      }
    }

    const formatDate = (dateString) => {
      return new Date(dateString).toLocaleString()
    }

    const calculateDuration = (start, end) => {
      const duration = new Date(end) - new Date(start)
      const hours = Math.floor(duration / 3600000)
      const minutes = Math.floor((duration % 3600000) / 60000)
      return `${hours}h ${minutes}m`
    }

    onMounted(async () => {
      if (userRole.value !== 'user') {
        await fetchUsers()
      }
      await fetchWorkingTimes()
    })

    return {
      isDarkTheme,
      userRole,
      selectedUserId,
      displayedWorkingTimes,
      users,
      fetchWorkingTimes,
      formatDate,
      calculateDuration
    }
  }
}
</script>