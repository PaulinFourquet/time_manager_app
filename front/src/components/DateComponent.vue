<template>
    <div class="date-time">
      {{ currentDateTime }}
    </div>
  </template>
  
  <script>
  export default {
    name: 'DateComponent',
    data() {
      return {
        currentDateTime: this.formatDate(new Date())
      };
    },
    mounted() {
      this.updateDateTime();
    },
    methods: {
      updateDateTime() {
        setInterval(() => {
          this.currentDateTime = this.formatDate(new Date());
        }, 1000);
      },
      formatDate(date) {
        const days = ['Sun', 'Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat'];
        const dayName = days[date.getDay()];
        const day = date.getDate();
        const year = date.getFullYear();
        const hours = date.getHours() % 12 || 12;
        const minutes = date.getMinutes().toString().padStart(2, '0');
        const ampm = date.getHours() >= 12 ? 'PM' : 'AM';
        const formattedDate = `${dayName} ${day}, ${year} | ${hours}:${minutes} ${ampm}`;
        return formattedDate;
      }
    }
  };
  </script>