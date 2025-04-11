<template>
    <div :class="[isDarkTheme ? 'bg-InputBgGray2 text-white shadow-none' : 'bg-white text-black', 'create p-6 rounded-3xl shadow-md']">
      <h2 class="text-xl font-semibold mb-4">Create Working Time</h2>
      <div class="flex flex-col space-y-4">
        <p>Start Date</p>
        <input
          type="datetime-local" 
          v-model="start" 
          placeholder="Start Time" 
          class="border border-gray-300 p-2 rounded text-black"
        />
        <p>End Date</p>
        <input 
          type="datetime-local" 
          v-model="end" 
          placeholder="End Time" 
          class="border border-gray-300 p-2 rounded text-black"
        />
        <template v-if="userRole !== 'user'">
          <p>User ID</p>
          <input 
            type="text" 
            v-model="userId" 
            placeholder="User ID" 
            class="border border-gray-300 p-2 rounded text-black"
          />
        </template>
        <button 
          :disabled="!start || !end || (userRole !== 'user' && !userId)" 
          @click="handleCreate" 
          class="bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded disabled:opacity-50 disabled:cursor-not-allowed"
        >
          Create Working Time
        </button>
      </div>
    </div>
</template>
  
<script>
  import { ref } from 'vue'
  
  export default {
    props: ['userRole', 'loggedInUserId', 'isDarkTheme'],
    emits: ['create-working-time'],
    setup(props, { emit }) {
      const start = ref('')
      const end = ref('')
      const userId = ref('')
  
      const handleCreate = () => {
        const userIdToUse = props.userRole === 'user' ? props.loggedInUserId : userId.value
        emit('create-working-time', {
          start: start.value,
          end: end.value,
          userId: userIdToUse
        })
      }
  
      return { start, end, userId, handleCreate }
    }
  }
</script>