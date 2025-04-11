<template>
  <div class="min-h-screen flex flex-col lg:flex-row items-center justify-between bg-[#1B2C3C]">
    <div
      class="hidden lg:flex flex-1 flex-col justify-center items-center max-w-md w-full lg:max-w-full"
    >
      <div class="w-full lg:w-3/4 space-y-8">
       <router-link to="/" class="text-white underline">{{ '<' }} Back to Home</router-link>

        <h2 class="mt-6 text-center text-3xl font-extrabold text-[#fdfc4c] font-bangers">Login</h2>
        <form class="mt-8 space-y-6" @submit.prevent="login">
          <div class="rounded-md shadow-sm -space-y-px">
            <div>
              <label for="email" class="sr-only">Email address</label>
              <input
                id="email"
                name="email"
                type="email"
                v-model="email"
                required
                class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                placeholder="Email address"
              />
            </div>
            <div>
              <label for="password" class="sr-only">Password</label>
              <input
                id="password"
                name="password"
                type="password"
                v-model="password"
                required
                class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-b-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                placeholder="Password"
              />
            </div>
          </div>

          <p class="text-center text-sm text-white">
            Not registered yet?
            <router-link to="/register" class="text-indigo-600 hover:text-indigo-500"
              >Create one here</router-link
            >
          </p>
          <div>
            <button
              type="submit"
              class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            >
              Login
            </button>
          </div>
        </form>
        <p v-if="error" class="mt-2 text-center text-sm text-red-600">{{ error }}</p>
      </div>
    </div>

    <div class="relative flex-1 flex justify-center items-center w-full lg:justify-end lg:mt-0">
      <img :src="gif" alt="Animation" class="w-full h-[100vh] object-cover" />

      <div class="absolute inset-0 flex justify-center items-center lg:hidden">
        <div class="w-full max-w-md space-y-8 bg-[#1B2C3C] bg-opacity-80 p-5 rounded-lg">
         <router-link to="/" class="text-white underline">{{ '<' }} Back to Home</router-link>

          <h2 class="text-center text-3xl font-extrabold text-[#fdfc4c] font-bangers">Login</h2>
          <form class="space-y-6" @submit.prevent="login">
            <div class="rounded-md shadow-sm -space-y-px">
              <div>
                <label for="email" class="sr-only">Email address</label>
                <input
                  id="email"
                  name="email"
                  type="email"
                  v-model="email"
                  required
                  class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                  placeholder="Email address"
                />
              </div>
              <div>
                <label for="password" class="sr-only">Password</label>
                <input
                  id="password"
                  name="password"
                  type="password"
                  v-model="password"
                  required
                  class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-b-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                  placeholder="Password"
                />
              </div>
            </div>

            <p class="text-center text-sm text-white">
              Not registered yet?
              <router-link to="/register" class="text-indigo-600 hover:text-indigo-500"
                >Create one here</router-link
              >
            </p>

            <div>
              <button
                type="submit"
                class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
              >
                Login
              </button>
            </div>
          </form>
          <p v-if="error" class="mt-2 text-center text-sm text-red-600">{{ error }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import gif from '@/assets/t-p-o-o.gif'

export default {
  name: 'Login',
  data() {
    return {
      email: '',
      password: '',
      error: null,
      gif
    }
  },
  methods: {
    async login() {
      if (this.email && this.password) {
        try {
          await this.$store.dispatch('login', {
            email: this.email,
            password: this.password
          })
        } catch (error) {
          this.error = 'Login failed. Please check your credentials.'
        }
      }
    }
  }
}
</script>
