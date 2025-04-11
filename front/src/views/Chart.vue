<template>
<div class="min-h-screen w-full bg-cover bg-center bg-fixed shadow-sm border-t-[0.1%] border-l-[0.1%] border-[#000000] rounded-tl-[2%] pl-[0.5%] pr-[0.5%] xl:pl-[0.9%] xl:pr-[0.9%]" :style="{ backgroundImage: bgimage }">
    <div class="flex items-start h-full mt-6">
        <div class="flex flex-col items-center mr-4 w-8 h-full">
            <span class="text-bluePurple text-4xl mb-1 flex-shrink-0">●</span>
            <div class="w-px bg-white flex-grow"></div>
        </div>
        <div class="flex-grow">
            <h1 :class="['text-2xl font-poppins font-medium', isDarkTheme ? 'text-white' : 'text-black']">Charts</h1>
            <ChartManager />
        </div>
    </div>
</div>
</template>
  
<script>
  import { useTheme } from '@/composables/useTheme'
  import ChartManager from '@/components/Clock/ChartManager.vue'
    
  export default {
    name: 'ChartView',
    components: { ChartManager },
    setup() {
      const { isDarkTheme } = useTheme()
      const bgimage = 'url(/src/assets/bg-dashboard.jpeg)'
  
      return {
        isDarkTheme,
        bgimage
      }
    }
  }
</script>