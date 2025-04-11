<template>
    <div :class="[isDarkTheme ? 'bg-InputBgGray2 text-white shadow-none' : 'bg-white text-black', 'modifying p-6 rounded-3xl shadow-md']">
      <h3 class="text-xl font-semibold mb-4">View/Modify Working Time</h3>
      <div class="flex flex-col space-y-4">
        <p>Start Date</p>
        <input 
          type="datetime-local" 
          v-model="startDisplayLocal" 
          placeholder="Start Time" 
          class="border border-gray-300 p-2 rounded text-black"
        />
        <p>End Date</p>
        <input 
          type="datetime-local" 
          v-model="endDisplayLocal" 
          placeholder="End Time" 
          class="border border-gray-300 p-2 rounded text-black"
        />
        <p>Working Time ID</p>
        <input 
          type="text" 
          v-model="workingTimeIdLocal" 
          placeholder="Working Time ID" 
          class="border border-gray-300 p-2 rounded text-black"
        />
        <button 
          :disabled="!startDisplayLocal || !endDisplayLocal || !userIdModify || !workingTimeIdLocal" 
          @click="handleUpdate" 
          class="bg-yellow-500 hover:bg-yellow-600 text-white font-semibold py-2 px-4 rounded disabled:opacity-50 disabled:cursor-not-allowed"
        >
          Modify Working Time
        </button>
      </div>
    </div>
</template>
  
<script>
  import { ref, watch } from 'vue'
  
  export default {
    props: ['isDarkTheme', 'startDisplay', 'endDisplay', 'workingTimeId', 'userIdModify'],
    emits: ['update-working-time'],
    setup(props, { emit }) {
      const startDisplayLocal = ref(props.startDisplay)
      const endDisplayLocal = ref(props.endDisplay)
      const workingTimeIdLocal = ref(props.workingTimeId)
  
      watch(() => props.startDisplay, (newVal) => startDisplayLocal.value = newVal)
      watch(() => props.endDisplay, (newVal) => endDisplayLocal.value = newVal)
      watch(() => props.workingTimeId, (newVal) => workingTimeIdLocal.value = newVal)
  
      const handleUpdate = () => {
        emit('update-working-time', {
          start: startDisplayLocal.value,
          end: endDisplayLocal.value,
          workingTimeId: workingTimeIdLocal.value
        })
      }
  
      return { startDisplayLocal, endDisplayLocal, workingTimeIdLocal, handleUpdate }
    }
  }
</script>