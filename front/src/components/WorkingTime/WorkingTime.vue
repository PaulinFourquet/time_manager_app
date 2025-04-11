<script>
import { ref, computed } from 'vue'
import { useStore } from 'vuex'
import { useTheme } from '@/composables/useTheme'
import create from '@/components/WorkingTime/utils/create.vue'
import display from '@/components/WorkingTime/utils/display.vue'
import modify from '@/components/WorkingTime/utils/modify.vue'
import moment from 'moment'
import apiClient from '@/services/api'

export default {
  name: 'WorkingTime',
  components: {
    create,
    display,
    modify
  },
  setup() {
    const store = useStore()
    const { isDarkTheme } = useTheme()
    const userRole = computed(() => store.state.auth.userRole)
    const loggedInUserId = computed(() => store.state.auth.userId)

    const start = ref('')
    const end = ref('')
    const userId = ref('')
    const displayedWorkingTime = ref('')
    const startDisplay = ref('')
    const endDisplay = ref('')
    const userIdModify = ref('')
    const workingTimeId = ref('')
    const requestedUserId = ref('')
    const requestedWorkingTime = ref('')

    const createWorkingTime = async () => {
      try {
        const startFormatted = moment(start.value).format('YYYY-MM-DD HH:mm:ss')
        const endFormatted = moment(end.value).format('YYYY-MM-DD HH:mm:ss')
        const userIdToUse = userRole.value === 'user' ? loggedInUserId.value : userId.value
        const response = await apiClient.createWT(userIdToUse, { start: startFormatted, end: endFormatted })
      } catch (error) {
        console.error('Error creating working time:', error)
      }
    }

    const displayWorkingTime = async () => {
      try {
        const userIdToUse = userRole.value === 'user' ? loggedInUserId.value : requestedUserId.value
        const response = (await apiClient.getWorkingTimeByUserAndId(userIdToUse, requestedWorkingTime.value)).data.data
        startDisplay.value = moment(response.start).utc().format('YYYY-MM-DDTHH:mm:ss')
        endDisplay.value = moment(response.end).utc().format('YYYY-MM-DDTHH:mm:ss')
        userIdModify.value = response.user_id
        workingTimeId.value = response.id
      } catch (error) {
        console.error('Error displaying working time:', error)
      }
    }

    const updateWorkingTime = async () => {
      try {
        const startFormatted = moment(startDisplay.value).format('YYYY-MM-DD HH:mm:ss')
        const endFormatted = moment(endDisplay.value).format('YYYY-MM-DD HH:mm:ss')
        await apiClient.updateWT(workingTimeId.value, { start: startFormatted, end: endFormatted })
      } catch (error) {
        console.error('Error updating working time:', error)
      }
    }

    const deleteWorkingTime = async () => {
      try {
        await apiClient.deleteWT(requestedWorkingTime.value)
      } catch (error) {
        console.error('Error deleting working time:', error)
      }
    }

    return {
      userRole,
      loggedInUserId,
      isDarkTheme,
      start,
      end,
      userId,
      displayedWorkingTime,
      startDisplay,
      endDisplay,
      userIdModify,
      workingTimeId,
      requestedUserId,
      requestedWorkingTime,
      createWorkingTime,
      displayWorkingTime,
      updateWorkingTime,
      deleteWorkingTime
    }
  }
}
</script>

<template>
  <div :class="[isDarkTheme ? 'bg-InputBgGray text-white shadow-none' : 'bg-white text-black', 'mt-4 working-time p-6 rounded-3xl space-y-8']">
    <create 
      :userRole="userRole"
      :loggedInUserId="loggedInUserId"
      :isDarkTheme="isDarkTheme"
      @create-working-time="createWorkingTime"
    />
    
    <display 
      :userRole="userRole"
      :isDarkTheme="isDarkTheme"
      @display-working-time="displayWorkingTime"
      @delete-working-time="deleteWorkingTime"
    />
    
    <modify 
      :isDarkTheme="isDarkTheme"
      :startDisplay="startDisplay"
      :endDisplay="endDisplay"
      :workingTimeId="workingTimeId"
      :userIdModify="userIdModify"
      @update-working-time="updateWorkingTime"
    />
  </div>
</template>