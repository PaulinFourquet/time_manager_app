<template>
<div class="min-h-screen w-full bg-cover bg-center bg-fixed shadow-sm border-t-[0.1%] border-l-[0.1%] border-[#000000] rounded-tl-[2%] pl-[0.5%] pr-[0.5%] xl:pl-[0.9%] xl:pr-[0.9%]" :style="{ backgroundImage: 'url(/src/assets/bg-dashboard.jpeg)' }">
    <div className="h-full xl:ml-4">
      <div class="flex flex-col space-y-8 w-full h-full">
        <div class="flex items-start h-full mt-8">
          <div class="flex flex-col items-center mr-4 w-8 h-full">
            <span class="text-bluePurple text-4xl mb-1 flex-shrink-0">●</span>
            <div class="w-px bg-white flex-grow"></div>
          </div>
          <div class="flex-grow">
            <h1 :class="['text-2xl font-poppins font-medium mb-6', isDarkTheme ? 'text-white' : 'text-white']">Create</h1>
            <create 
              :userRole="userRole"
              :loggedInUserId="loggedInUserId"
              :isDarkTheme="isDarkTheme"
              @create-working-time="createWorkingTime"
            />
          </div>
        </div>
        <div class="flex items-start h-full mt-8">
          <div class="flex flex-col items-center mr-4 w-8 h-full">
            <span class="text-bluePurple text-4xl mb-1 flex-shrink-0">●</span>
            <div class="w-px bg-white flex-grow"></div>
          </div>
          <div class="flex-grow">
            <h1 :class="['text-2xl font-poppins font-medium mb-6', isDarkTheme ? 'text-white' : 'text-white']">Modify</h1>
            <modify 
              :isDarkTheme="isDarkTheme"
              :startDisplay="startDisplay"
              :endDisplay="endDisplay"
              :workingTimeId="workingTimeId"
              :userIdModify="userIdModify"
              @update-working-time="updateWorkingTime"
            />
          </div>
        </div>
        <div class="flex items-start h-full mt-8">
          <div class="flex flex-col items-center mr-4 w-8 h-full">
            <span class="text-bluePurple text-4xl mb-1 flex-shrink-0">●</span>
            <div class="w-px bg-white flex-grow"></div>
          </div>
          <div class="flex-grow">
            <h1 :class="['text-2xl font-poppins font-medium mb-6', isDarkTheme ? 'text-white' : 'text-white']">Display</h1>
            <display 
              :userRole="userRole"
              :isDarkTheme="isDarkTheme"
              @display-working-time="displayWorkingTime"
              @delete-working-time="deleteWorkingTime"
            />
          </div>
        </div>
        <div class="flex items-start h-full mt-8">
          <div class="flex flex-col items-center mr-4 w-8 h-full">
            <span class="text-bluePurple text-4xl mb-1 flex-shrink-0">●</span>
            <div class="w-px bg-white flex-grow"></div>
          </div>
          <div class="flex-grow">
            <h1 :class="['text-2xl font-poppins font-medium mb-6', isDarkTheme ? 'text-white' : 'text-white']">Display</h1>
            <WorkingTimes />
          </div>
        </div>
      </div>
    </div>
</div>
</template>
  
<script>
  import { ref, computed } from 'vue'
  import { useStore } from 'vuex'
  import { useTheme } from '@/composables/useTheme'
  import create from '@/components/WorkingTime/utils/create.vue'
  import display from '@/components/WorkingTime/utils/display.vue'
  import modify from '@/components/WorkingTime/utils/modify.vue'
  import WorkingTimes from '@/components/WorkingTime/WorkingTimes.vue'
  import moment from 'moment'
  import apiClient from '@/services/api'
  
  export default {
    name: 'Home',
    components: {
        create,
        display,
        modify,
        WorkingTimes
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

      const createWorkingTime = async (data) => {
        try {
          const startFormatted = moment(data.start).format('YYYY-MM-DD HH:mm:ss')
          const endFormatted = moment(data.end).format('YYYY-MM-DD HH:mm:ss')
          const response = await apiClient.createWT(data.userId, { start: startFormatted, end: endFormatted })
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