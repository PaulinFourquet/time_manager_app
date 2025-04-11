<template>
<div class="overflow-hidden">
  <Layout>
    <router-view></router-view>
  </Layout>
</div>
</template>

<script>
import Layout from '@/components/Layout.vue'


export default {
  name: 'App',
  components: {
    Layout
  },
  async created() {
    await this.$store.dispatch('checkAuth')
  }
}
</script>