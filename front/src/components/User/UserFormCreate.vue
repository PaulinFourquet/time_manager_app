<template>
  <div :class="[isDarkTheme ? 'bg-bgButtonGray text-white shadow-none' : 'bg-white text-black', 'w-[80%] mr-auto ml-auto p-6 h-full rounded-3xl shadow-lg shadow-gray-400/90']">
    <h1 class="text-3xl font-medium text-center mb-6 font-poppins">Create User</h1>
    <form @submit.prevent="createUser">
      <div class="mb-6">
        <label for="username" :class="[isDarkTheme ? 'text-gray-300' : 'text-gray-600', 'block text-xs font-medium font-poppins']">User name</label>
        <input type="text" id="username" name="username" placeholder="User name"
          v-model="username"
          :class="[isDarkTheme ? 'bg-InputBgGray border-LightGray' : 'border-bluePurple placeholder-gray-300', 'mt-1 block w-full px-4 py-2 border rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-bluePurple focus:border-transparent']">
      </div>

      <div class="mb-8">
        <label for="email" :class="[isDarkTheme ? 'text-gray-300' : 'text-gray-600', 'block text-xs font-medium font-poppins']">Email</label>
        <input type="email" id="email" name="email" placeholder="email"
          v-model="email"
          :class="[isDarkTheme ? 'bg-InputBgGray border-LightGray' : 'border-bluePurple placeholder-gray-300', 'mt-1 block w-full px-4 py-2 border rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-bluePurple focus:border-transparent']">
      </div>

      <div class="mb-8">
        <label for="password" :class="[isDarkTheme ? 'text-gray-300' : 'text-gray-600', 'block text-xs font-medium font-poppins']">Password</label>
        <input type="password" id="password" name="password" placeholder="password"
          v-model="password"
          :class="[isDarkTheme ? 'bg-InputBgGray border-LightGray' : 'border-bluePurple placeholder-gray-300', 'mt-1 block w-full px-4 py-2 border rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-bluePurple focus:border-transparent']">
      </div>

      <div class="flex justify-center ">
        <button type="submit"
          :class="[isDarkTheme ? ' shadow-none shadow-gray-400/90 transition-colors px-8 py-2 text-white bg-bluePurple rounded-lg hover:bg-bluePurpleHover focus:outline-none focus:ring-2 focus:ring-bluePurple focus:ring-opacity-50' : 'shadow-lg shadow-gray-400/90 transition-colors px-8 py-2 text-white bg-bluePurple rounded-lg hover:bg-bluePurpleHover focus:outline-none focus:ring-2 focus:ring-bluePurple focus:ring-opacity-50']"
        >
          Create
        </button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useTheme } from '@/composables/useTheme'
import api from '@/services/api'

const emit = defineEmits(['userCreated'])

const { isDarkTheme } = useTheme()

const username = ref('')
const email = ref('')
const password = ref('')

const createUser = async () => {
  try {
    const userData = {
      username: username.value,
      email: email.value,
      password: password.value
    }
    await api.createUser(userData)
    username.value = ''
    email.value = ''
    password.value = ''
    emit('userCreated')
  } catch (error) {
    console.error('Error creating user:', error)
  }
}
</script>