<template>
    <div :class="[isDarkTheme ? 'bg-InputBgGray2 text-white shadow-none' : 'bg-white text-black', 'display p-6 rounded-3xl shadow-md']">
      <h2 class="text-xl font-semibold mb-4">Display And Delete Working Time</h2>
      <div class="flex flex-col space-y-4">
        <p v-if="userRole !== 'user'">User ID</p>
        <input 
          v-if="userRole !== 'user'"
          type="text" 
          v-model="requestedUserId" 
          placeholder="User ID" 
          class="border border-gray-300 p-2 rounded"
        />
        <p>Working Time ID</p>
        <input 
          type="text" 
          v-model="requestedWorkingTime" 
          placeholder="Working Time ID" 
          class="border border-gray-300 p-2 rounded"
        />
        <button 
          :disabled="(userRole !== 'user' && !requestedUserId) || !requestedWorkingTime" 
          @click="handleDisplay" 
          class="bg-green-500 hover:bg-green-600 text-white font-semibold py-2 px-4 rounded disabled:opacity-50 disabled:cursor-not-allowed"
        >
          Display Working Time
        </button>
        <button 
          v-if="userRole !== 'user'"
          :disabled="!requestedUserId || !requestedWorkingTime" 
          @click="handleDelete" 
          class="bg-red-500 hover:bg-red-600 text-white font-semibold py-2 px-4 rounded disabled:opacity-50 disabled:cursor-not-allowed"
        >
          Delete Working Time
        </button>
      </div>
    </div>
</template>
  
<script>
  import { ref } from 'vue'
  
  export default {
    props: ['userRole', 'isDarkTheme'],
    emits: ['display-working-time', 'delete-working-time'],
    setup(props, { emit }) {
      const requestedUserId = ref('')
      const requestedWorkingTime = ref('')
  
      const handleDisplay = () => {
        emit('display-working-time', {
          userId: requestedUserId.value,
          workingTimeId: requestedWorkingTime.value
        })
      }
  
      const handleDelete = () => {
        emit('delete-working-time', requestedWorkingTime.value)
      }
  
      return { requestedUserId, requestedWorkingTime, handleDisplay, handleDelete }
    }
  }
</script>