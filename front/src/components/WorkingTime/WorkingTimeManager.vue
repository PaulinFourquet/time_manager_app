<template>
    <div className="xl:ml-4">
        <WorkingTime />
        <WorkingTimes />        
    </div>
  </template>
  
  <script>
  import WorkingTimes from './WorkingTimes.vue';
  import WorkingTime from './WorkingTime.vue';
  
  export default {
    name: 'WorkingTimeManager',
    components: {
      WorkingTime,
      WorkingTimes
    },
  }
  </script>