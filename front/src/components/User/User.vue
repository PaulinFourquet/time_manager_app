<template>
  <div class="xl:ml-4">
    <div class="grid grid-cols-1 xl:grid-cols-8 gap-4 lg:w-full">
      <div class="rounded-md w-full xl:col-span-5">
        <UserTable />
      </div>
      <div class="xl:pl-8 rounded-md w-full xl:col-span-2 xl:mt-4" v-if="userRole !== 'user'">
        <UserFormCreate />
      </div>
    </div>
  </div>
</template>

<script>
import { computed } from 'vue'
import { useStore } from 'vuex'
import UserTable from './UserTable.vue';
import UserFormCreate from './UserFormCreate.vue';

export default {
  name: 'Home',
  components: {
    UserTable,
    UserFormCreate,
  },
  setup() {
    const store = useStore()
    const userRole = computed(() => store.state.auth.userRole)
    const userId = computed(() => store.state.auth.userId)

    return {
      userRole,
      userId
    }
  }
}
</script>