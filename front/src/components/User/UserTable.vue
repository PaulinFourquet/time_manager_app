<template>
  <div class="flex justify-center items-center pt-4 pb-4">
    <div
      v-if="!isMobile"
      :class="[
        isDarkTheme ? 'bg-bgButtonGray text-white shadow-none' : 'bg-white text-black',
        'w-full max-w-4xl h-auto rounded-3xl shadow-lg shadow-gray-400/90 p-4'
      ]"
    >
      <div class="px-4 sm:px-6 lg:px-8">
        <div class="flow-root">
          <div class="overflow-x-auto">
            <div class="inline-block min-w-full align-middle">
              <table
                class="min-w-full divide-y"
                :class="[isDarkTheme ? 'divide-gray-700' : 'divide-gray-300']"
              >
                <thead
                  class="text-left text-sm font-semibold"
                  :class="[isDarkTheme ? 'text-LightGray' : 'text-gray-900']"
                >
                  <tr class="pl-4 xl:pl-16 text-left text-sm font-semibold font-poppins">
                    <th scope="col">Id</th>
                    <th scope="col">Name</th>
                    <th scope="col">Email</th>
                    <th scope="col">Role</th>
                    <th scope="col">Action</th>
                  </tr>
                </thead>
                <tbody
                  :class="[
                    isDarkTheme ? 'divide-gray-700 bg-bgButtonGray' : 'bg-white divide-gray-200'
                  ]"
                >
                  <tr v-if="displayedUsers.length === 0">
                    <td
                      colspan="5"
                      class="text-center py-4"
                      :class="[isDarkTheme ? 'text-LightGray' : 'text-gray-900']"
                    >
                      No users found.
                    </td>
                  </tr>
                  <tr
                    v-for="(user, index) in displayedUsers"
                    :key="user.id"
                    :class="[isDarkTheme ? 'hover:bg-gray-600' : 'hover:bg-gray-50']"
                  >
                    <td
                      class="whitespace-nowrap py-2 pl-4 pr-3 text-sm sm:pl-0"
                      :class="[isDarkTheme ? 'text-LightGray' : 'text-gray-900']"
                    >
                      <div class="flex items-center">
                        <div
                          :class="[
                            isDarkTheme
                              ? 'bg-gray-700 text-LightGray'
                              : 'bg-gray-300 text-gray-900',
                            'h-8 w-8 rounded-full flex items-center justify-center'
                          ]"
                        >
                          {{ user.username.charAt(0).toUpperCase() }}
                        </div>
                        <div class="ml-4 xl:ml-8">
                          <div
                            class="text-sm font-medium"
                            :class="[isDarkTheme ? 'text-LightGray' : 'text-gray-900']"
                          >
                            {{ user.id }}
                          </div>
                        </div>
                      </div>
                    </td>

                    <td
                      class="whitespace-nowrap px-3 py-2 text-sm"
                      :class="[isDarkTheme ? 'text-LightGray' : 'text-gray-900']"
                    >
                      <a :class="[isDarkTheme ? 'text-LightGray' : 'text-blue-600']">{{
                        user.username
                      }}</a>
                    </td>

                    <td
                      class="whitespace-nowrap px-3 py-2 text-sm"
                      :class="[isDarkTheme ? 'text-LightGray' : 'text-gray-900']"
                    >
                      <a :class="[isDarkTheme ? 'text-LightGray' : 'text-blue-600']">{{
                        user.email
                      }}</a>
                    </td>

                    <td
                      class="whitespace-nowrap px-3 py-2 text-sm"
                      :class="[isDarkTheme ? 'text-LightGray' : 'text-gray-900']"
                    >
                      <div :class="[isDarkTheme ? 'text-LightGray' : 'text-gray-900']">
                        {{ user.role }}
                      </div>
                    </td>

                    <td class="whitespace-nowrap px-3 py-2 text-sm">
                      <button
                        @click="editUser(user)"
                        :class="[
                          isDarkTheme ? 'bg-blue-600 text-LightGray' : 'bg-blue-100 text-blue-500',
                          'px-3 py-1 rounded-lg'
                        ]"
                      >
                        edit
                      </button>
                      <button
                        v-if="userRole !== 'user'"
                        @click="deleteUser(user.id)"
                        :class="[
                          isDarkTheme ? 'bg-red-600 text-LightGray' : 'bg-red-100 text-red-500',
                          'px-3 py-1 rounded-lg ml-2'
                        ]"
                      >
                        delete
                      </button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div v-if="editingUser" class="mt-8 p-4 bg-white rounded-lg shadow">
              <h2 class="text-lg font-semibold mb-4">Edit User</h2>
              <form @submit.prevent="saveUser" class="space-y-4">
                <div>
                  <label for="edit-username" class="block text-sm font-medium text-gray-700">Username</label>
                  <input
                    id="edit-username"
                    v-model="userForm.username"
                    type="text"
                    required
                    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"
                  />
                </div>
                <div>
                  <label for="edit-email" class="block text-sm font-medium text-gray-700">Email</label>
                  <input
                    id="edit-email"
                    v-model="userForm.email"
                    type="email"
                    required
                    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"
                  />
                </div>
                <div>
                  <label for="edit-password" class="block text-sm font-medium text-gray-700">Password (required to update)</label>
                  <input
                    id="edit-password"
                    v-model="userForm.password"
                    type="password"
                    required
                    placeholder="Enter new password"
                    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"
                  />
                </div>
                <div class="flex justify-end space-x-2">
                  <button type="button" @click="cancelEdit" class="px-4 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                    Cancel
                  </button>
                  <button type="submit" class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                    Save Changes
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div v-else class="w-full max-w-2xl space-y-4">
      <div
        v-for="user in displayedUsers"
        :key="user.id"
        :class="[
          isDarkTheme ? 'bg-bgButtonGray text-white' : 'bg-white text-black',
          'rounded-3xl shadow-lg p-4'
        ]"
      >
        <div class="flex items-center mb-2">
          <div
            :class="[
              isDarkTheme ? 'bg-gray-700 text-LightGray' : 'bg-gray-300 text-gray-900',
              'h-10 w-10 rounded-full flex items-center justify-center'
            ]"
          >
            {{ user.username.charAt(0).toUpperCase() }}
          </div>
          <div class="ml-4">
            <div
              class="text-lg font-semibold"
              :class="[isDarkTheme ? 'text-LightGray' : 'text-gray-900']"
            >
              {{ user.username }}
            </div>
            <div class="text-sm" :class="[isDarkTheme ? 'text-LightGray' : 'text-gray-600']">
              {{ user.email }}
            </div>
          </div>
        </div>
        <div class="text-sm mb-2" :class="[isDarkTheme ? 'text-LightGray' : 'text-gray-900']">
          <strong>Role:</strong> {{ user.role }}
        </div>
        <div class="space-x-2">
          <button
            v-if="userRole !== 'user'"
            @click="editUser(user)"
            :class="[
              isDarkTheme ? 'bg-blue-600 text-LightGray' : 'bg-blue-100 text-blue-500',
              'px-3 py-1 rounded-lg'
            ]"
          >
            edit
          </button>
          <button
            v-if="userRole !== 'user'"
            @click="deleteUser(user.id)"
            :class="[
              isDarkTheme ? 'bg-red-600 text-LightGray' : 'bg-red-100 text-red-500',
              'px-3 py-1 rounded-lg'
            ]"
          >
            delete
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { useTheme } from '@/composables/useTheme'
import { useStore } from 'vuex'
import { computed, ref, onMounted, onUnmounted } from 'vue'
import api from '@/services/api'

export default {
  name: 'User',
  setup() {
    const { isDarkTheme } = useTheme()
    const store = useStore()
    const userRole = computed(() => store.state.auth.userRole)
    const loggedInUserId = computed(() => store.state.auth.userId)
    const isMobile = ref(window.innerWidth < 768)

    const handleResize = () => {
      isMobile.value = window.innerWidth < 768
    }

    onMounted(() => {
      window.addEventListener('resize', handleResize)
    })

    onUnmounted(() => {
      window.removeEventListener('resize', handleResize)
    })

    return { isDarkTheme, userRole, loggedInUserId, isMobile }
  },
  data() {
    return {
      users: [],
      userForm: {
        username: '',
        email: '',
        password: ''
      },
      editingUser: null
    }
  },
  computed: {
    displayedUsers() {
      if (this.userRole === 'user') {
        return this.users.filter((user) => user.id === Number(this.loggedInUserId))
      }
      return this.users
    }
  },
  methods: {
    async fetchUsers() {
      try {
        let response
        if (this.userRole === 'user') {
          response = await api.listUsers({ id: this.loggedInUserId })
        } else {
          response = await api.listUsers()
        }
        if (response.data && Array.isArray(response.data.data)) {
          this.users = response.data.data
        } else if (response.data && typeof response.data === 'object') {
          this.users = [response.data]
        } else {
          this.users = []
        }
      } catch (error) {
        this.users = []
      }
    },
    editUser(user) {
      this.editingUser = user
      this.userForm = { 
        username: user.username, 
        email: user.email,
        password: ''
      }
    },
    cancelEdit() {
      this.editingUser = null
      this.userForm = { username: '', email: '', password: '' }
    },
    async saveUser() {
      try {
        const updatedUser = { ...this.userForm }
        if (!updatedUser.password) {
          throw new Error("Password is required to update the profile.")
        }
        await api.updateUser(this.editingUser.id, updatedUser)
        await this.fetchUsers()
        this.cancelEdit()
      } catch (error) {
        console.error('Error updating user:', error)
      }
    },
    async deleteUser(userId) {
      if (confirm('Are you sure you want to delete this user?')) {
        try {
          await api.deleteUser(userId)
          await this.fetchUsers()
        } catch (error) {
          console.error(error)
        }
      }
    }
  },
  mounted() {
    this.fetchUsers()
  }
}
</script>
