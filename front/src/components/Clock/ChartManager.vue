<template>
  <div class="xl:ml-4">
    <div class="grid grid-cols-1 xl:grid-cols-6 gap-4 mt-6">
      <!-- Bloc 1: User Manager (1/6) -->
      <div v-if="userRole !== 'user'" :class="[isDarkTheme ? 'bg-InputBgGray text-white shadow-none' : 'bg-white text-black', 'col-span-1 xl:col-span-2 p-8 h-max xl:h-[464px] rounded-3xl shadow-lg shadow-gray-400/90']">
        <h1 class="text-2xl font-medium text-center mb-4 font-poppins">User Chart Manager</h1>
        <div class="mb-6">
          <label for="user-select" :class="[isDarkTheme ? 'text-gray-300' : 'text-gray-600', 'block text-xs font-medium font-poppins']">Select User</label>
          <select id="user-select" v-model="selectedUserId" @change="onUserSelect"
            :class="[isDarkTheme ? 'bg-InputBgGray border-LightGray text-white' : 'border-bluePurple placeholder-gray-300 text-black', 'mt-1 block w-full px-4 py-2 border rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-bluePurple focus:border-transparent']">
            <option value="">Select a user</option>
            <option v-for="user in users" :key="user.id" :value="user.id">
              {{ user.username }} (ID: {{ user.id }})
            </option>
          </select>
        </div>
        <div class="mt-4 flex justify-center px-2 py-2">
          <button @click="setUserId" :disabled="!selectedUserId"
            :class="[isDarkTheme ? 'shadow-none shadow-gray-400/90 transition-colors px-8 py-2 text-white bg-bluePurple rounded-lg hover:bg-bluePurpleHover focus:outline-none focus:ring-2 focus:ring-bluePurple focus:ring-opacity-50' : 'shadow-lg shadow-gray-400/90 transition-colors px-8 py-2 text-white bg-bluePurple rounded-lg hover:bg-bluePurpleHover focus:outline-none focus:ring-2 focus:ring-bluePurple focus:ring-opacity-50', !selectedUserId ? 'opacity-50 cursor-not-allowed' : '']">
            Set User
          </button>
        </div>
        <div v-if="errorMessage" class="mt-4 text-sm text-red-500 text-center">
          {{ errorMessage }}
        </div>
      </div>

      <!-- Bloc 2: Weekly Worked Hours (4/6) -->
      <div v-if="userId" :class="[isDarkTheme ? 'bg-InputBgGray text-white shadow-none' : 'bg-white text-black', 'col-span-1 xl:col-span-4 p-8 h-max rounded-3xl shadow-lg shadow-gray-400/90']">
        <h1 class="text-2xl font-medium text-center mb-4 font-poppins">Weekly Worked Hours</h1>
        <div class="mb-4 flex flex-col items-center">
          <label for="month-select" :class="[isDarkTheme ? 'text-gray-300' : 'text-gray-600', 'block text-xs font-medium font-poppins']">Select Month</label>
          <input type="month" id="month-select" v-model="selectedMonth" @change="updateBarChart"
            :class="[isDarkTheme ? 'bg-InputBgGray border-LightGray' : 'placeholder-gray-300', 'border-bluePurple hover:border-bluePurpleHover mt-1 block px-4 py-2 border rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-bluePurple focus:border-transparent']">
        </div>
        <div class="h-64">
          <Bar v-if="barChartData && barChartData.datasets.length" :data="barChartData" :options="barChartOptions"
            class="w-full h-full" />
          <p v-else class="text-center text-gray-500 mt-8">No data available for monthly worked hours.</p>
        </div>
      </div>

      <!-- Bloc 3: Monthly Attendance Rate (1/6) -->
      <div v-if="userId" :class="[isDarkTheme ? 'bg-InputBgGray text-white shadow-none' : 'bg-white text-black', 'col-span-1 xl:col-span-2 p-8 h-max rounded-3xl shadow-lg shadow-gray-400/90']">
        <h1 class="text-2xl font-medium text-center mb-4 font-poppins">Monthly Attendance Rate</h1>
        <div class="mb-4 flex flex-col items-center">
          <label for="month-select" :class="[isDarkTheme ? 'text-gray-300' : 'text-gray-600', 'block text-xs font-medium font-poppins']">Select Month</label>
          <input type="month" id="attendance-month-select" v-model="selectedAttendanceMonth" @change="updatePieChart" 
          :class="[isDarkTheme ? 'bg-InputBgGray border-LightGray' : 'placeholder-gray-300', 'border-bluePurple hover:border-bluePurpleHover mt-1 block px-4 py-2 border rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-bluePurple focus:border-transparent']">
        </div>
        <div class="h-64">
          <Pie v-if="attendanceRateData && attendanceRateData.datasets.length" :data="attendanceRateData" :options="chartOptions" class="w-full h-full" />
          <p v-else class="text-center text-gray-500 mt-8">No data available for attendance rate chart.</p>
        </div>
      </div>

      <!-- Bloc 4: Daily Presence (1/6) -->
      <div v-if="userId" :class="[isDarkTheme ? 'bg-InputBgGray text-white shadow-none' : 'bg-white text-black', 'grid col-span-1 xl:col-span-4 p-8 h-max rounded-3xl shadow-lg shadow-gray-400/90']">
        <h1 class="text-2xl font-medium text-center mb-4 font-poppins">Daily Presence</h1>
        <div class="mb-4 flex flex-col items-center">
          <label for="month-select" :class="[isDarkTheme ? 'text-gray-300' : 'text-gray-600', 'block text-xs font-medium font-poppins']">Select Week</label>
          <input type="week" id="week-select" v-model="selectedWeek" @change="updateLineChart" 
          :class="[isDarkTheme ? 'bg-InputBgGray border-LightGray' : 'placeholder-gray-300', 'border-bluePurple hover:border-bluePurpleHover mt-1 block px-4 py-2 border rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-bluePurple focus:border-transparent']">
        </div>
        <div class="h-64">
          <Line v-if="lineChartData && lineChartData.datasets && lineChartData.datasets.length" :data="lineChartData" :options="lineChartOptions" class="chart" />
          <p v-else class="text-center text-gray-500 mt-8">No data available for daily presence chart.</p>
        </div>
      </div>

      <p v-if="!userId" class="text-center text-white">Please enter a user ID to view charts.</p>
      <p v-if="errorMessage" class="text-red-500 text-center mt-4 font-semibold">{{ errorMessage }}</p>
    </div>
  </div>
</template>

<script>
import { ref, computed, onMounted } from 'vue'
import { useStore } from 'vuex'
import { useTheme } from '@/composables/useTheme'
import { Bar, Line, Pie } from 'vue-chartjs'
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, LineElement, ArcElement, PointElement, CategoryScale, LinearScale } from 'chart.js'
import api from '@/services/api'

ChartJS.register(Title, Tooltip, Legend, BarElement, LineElement, ArcElement, PointElement, CategoryScale, LinearScale)

export default {
  name: 'ChartManager',
  components: { Bar, Line, Pie },
  setup() {
    const store = useStore()
    const { isDarkTheme } = useTheme()
    const userRole = computed(() => store.state.auth.userRole)
    const loggedInUserId = computed(() => store.state.auth.userId)

    const inputUserId = ref('')
    const userId = ref(null)
    const users = ref([])
    const selectedUserId = ref('')
    const workingHoursData = ref(null)
    const dailyPresenceData = ref(null)
    const attendanceRateData = ref(null)
    const errorMessage = ref(null)
    const lineChartData = ref(null)
    const barChartData = ref(null)
    const selectedMonth = ref(new Date().toISOString().slice(0, 7))
    const selectedWeek = ref(getDefaultWeek())
    const selectedAttendanceMonth = ref(new Date().toISOString().slice(0, 7))

    const barChartOptions = {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        x: {
          title: {
            display: true,
            text: 'Week of the Month'
          }
        },
        y: {
          beginAtZero: true,
          title: {
            display: true,
            text: 'Hours'
          }
        }
      },
      plugins: {
        tooltip: {
          callbacks: {
            label: function(context) {
              let label = context.dataset.label || '';
              if (label) {
                label += ': ';
              }
              if (context.parsed.y !== null) {
                label += context.parsed.y.toFixed(2) + ' hours';
              }
              return label;
            }
          }
        },
        legend: {
          display: true,
          position: 'top'
        }
      }
    }

    const chartOptions = {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        tooltip: {
          callbacks: {
            label: function(context) {
              let label = context.label || '';
              if (label) {
                label += ': ';
              }
              if (context.parsed !== undefined) {
                label += context.parsed.toFixed(1) + '%';
              }
              return label;
            }
          }
        },
        datalabels: {
          formatter: (value, ctx) => {
            return value.toFixed(1) + '%';
          },
          color: '#fff',
          font: {
            weight: 'bold',
            size: 16
          }
        }
      }
    }

    const lineChartOptions = {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        y: {
          reverse: true,
          min: 6,
          max: 22,
          ticks: {
            stepSize: 1,
            callback: function(value) {
              return value.toString().padStart(2, '0') + ':00';
            }
          }
        }
      },
      plugins: {
        tooltip: {
          callbacks: {
            label: function(context) {
              const value = context.parsed.y;
              const hours = Math.floor(value);
              const minutes = Math.round((value - hours) * 60);
              return `${context.dataset.label}: ${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}`;
            }
          }
        }
      }
    }

    function getDefaultWeek() {
      const now = new Date();
      const onejan = new Date(now.getFullYear(), 0, 1);
      const weekNumber = Math.ceil((((now - onejan) / 86400000) + onejan.getDay() + 1) / 7);
      return `${now.getFullYear()}-W${weekNumber.toString().padStart(2, '0')}`;
    }

    function onUserIdInput(event) {
      inputUserId.value = event.target.value.replace(/[^0-9]/g, '')
    }

    function setUserId() {
      if (selectedUserId.value) {
        userId.value = selectedUserId.value
        errorMessage.value = null
        fetchChartData()
      }
    }

    async function fetchChartData() {
      try {
        const workingTimeResponse = await api.getWorkingTime(userId.value)
        let workingTimeData = workingTimeResponse.data

        if (workingTimeData && Array.isArray(workingTimeData.data)) {
          workingTimeData = workingTimeData.data
        } else if (!Array.isArray(workingTimeData)) {
          throw new Error('Les données workingTime ne sont pas un tableau')
        }

        workingHoursData.value = workingTimeData
        updateBarChart()
        updatePieChart()

        const clocksResponse = await api.getClocks(userId.value)
        let clocksData = clocksResponse.data

        if (Array.isArray(clocksData)) {
          dailyPresenceData.value = clocksData
        } else if (clocksData && Array.isArray(clocksData.data)) {
          dailyPresenceData.value = clocksData.data
        } else {
          dailyPresenceData.value = null
          throw new Error('Les données clocks ne sont pas au format attendu.')
        }

        updateLineChart()
      } catch (error) {
        errorMessage.value = error.response ? error.response.data.message : error.message
        console.error('Erreur lors de la récupération des données:', error)
      }
    }

    async function fetchUsers() {
      try {
        const response = await api.listUsers()
        users.value = response.data.data
      } catch (error) {
        console.error('Error fetching users:', error)
      }
    }

    function onUserSelect() {
      userId.value = selectedUserId.value
      errorMessage.value = null
      if (userId.value) {
        fetchChartData()
      }
    }



    function updateBarChart() {
      barChartData.value = processBarChartData(workingHoursData.value, selectedMonth.value)
    }

    function updateLineChart() {
      if (!dailyPresenceData.value) {
        console.warn('No daily presence data available')
        lineChartData.value = null
        return
      }
      lineChartData.value = processDailyPresence(dailyPresenceData.value, selectedWeek.value)
    }

    function updatePieChart() {
      attendanceRateData.value = processAttendanceRate(workingHoursData.value, selectedAttendanceMonth.value)
    }

    function processBarChartData(data, selectedMonth) {
      if (!Array.isArray(data)) {
        console.error('Les données workingTime ne sont pas un tableau:', data);
        return { labels: [], datasets: [] };
      }

      if (!selectedMonth) {
        console.error('selectedMonth is undefined');
        selectedMonth = new Date().toISOString().slice(0, 7);
      }

      const [year, month] = selectedMonth.split('-');
      const monthData = data.filter(entry => {
        const entryDate = new Date(entry.start);
        return entryDate.getFullYear() === parseInt(year) && entryDate.getMonth() === parseInt(month) - 1;
      });

      const getWeekNumber = (date) => {
        const firstDayOfMonth = new Date(date.getFullYear(), date.getMonth(), 1);
        const dayOfWeek = firstDayOfMonth.getDay();
        const diff = date.getDate() + dayOfWeek - 1;
        return Math.ceil(diff / 7);
      };

      const weeklyHours = monthData.reduce((acc, entry) => {
        const startDate = new Date(entry.start);
        const weekNumber = getWeekNumber(startDate);
        const hours = (new Date(entry.end) - new Date(entry.start)) / (1000 * 60 * 60);
        
        if (!acc[weekNumber]) {
          acc[weekNumber] = 0;
        }
        acc[weekNumber] += hours;
        return acc;
      }, {});

      const labels = Object.keys(weeklyHours).sort((a, b) => parseInt(a) - parseInt(b))
        .map(week => `Week ${week}`);
      const datasetData = labels.map(week => weeklyHours[week.split(' ')[1]]);

      return {
        labels: labels,
        datasets: [
          {
            label: 'Worked Hours By Week',
            backgroundColor: '#f87979',
            data: datasetData,
          },
        ],
      };
    }

    function processDailyPresence(data, selectedWeek) {
      if (!data || !Array.isArray(data)) {
        console.error('Les données clocks ne sont pas un tableau:', data);
        return null;
      }

      if (!selectedWeek) {
        console.error('selectedWeek is undefined');
        return { labels: [], datasets: [] };
      }

      const [year, week] = selectedWeek.split('-W');
      const startDate = new Date(year, 0, (1 + (week - 1) * 7));
      const endDate = new Date(startDate.getTime() + 6 * 24 * 60 * 60 * 1000);

      const weekData = data.filter(clock => {
        const clockDate = new Date(clock.time);
        return clockDate >= startDate && clockDate <= endDate;
      });

      const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
      const entryTimes = Array(5).fill(null);
      const exitTimes = Array(5).fill(null);

      weekData.sort((a, b) => new Date(a.time) - new Date(b.time));

      for (const clock of weekData) {
        const date = new Date(clock.time);
        const dayIndex = date.getDay() - 1;
        const hours = date.getHours() + date.getMinutes() / 60;

        if (dayIndex >= 0 && dayIndex < 5) {
          if (clock.status === true) {
            if (entryTimes[dayIndex] === null || hours < entryTimes[dayIndex]) {
              entryTimes[dayIndex] = hours;
            }
          } else {
            if (exitTimes[dayIndex] === null || hours > exitTimes[dayIndex]) {
              exitTimes[dayIndex] = hours;
            }
          }
        }

        return {
          labels: days,
          datasets: [
            {
              label: "Entry Hours",
              data: entryTimes,
              borderColor: '#36A2EB',
              backgroundColor: '#36A2EB',
              fill: false,
              pointRadius: 6,
              pointHoverRadius: 8,
              showLine: false,
            },
            {
              label: 'Exit Hours',
              data: exitTimes,
              borderColor: '#FF6384',
              backgroundColor: '#FF6384',
              fill: false,
              pointRadius: 6,
              pointHoverRadius: 8,
              showLine: false,
            }
          ]
        };
      }
    }

    function processAttendanceRate(data, selectedMonth) {
      if (!Array.isArray(data)) {
        console.error('Les données workingTime pour le taux de présence ne sont pas un tableau:', data);
        return { labels: [], datasets: [] };
      }

      if (!selectedMonth) {
        console.error('selectedMonth is undefined');
        return { labels: [], datasets: [] };
      }

      const [year, month] = selectedMonth.split('-');
      const firstDayOfMonth = new Date(year, month - 1, 1);
      const lastDayOfMonth = new Date(year, month, 0);

      const monthData = data.filter(entry => {
        const entryDate = new Date(entry.start);
        return entryDate >= firstDayOfMonth && entryDate <= lastDayOfMonth;
      });

      let workdaysInMonth = 0;
      for (let d = new Date(firstDayOfMonth); d <= lastDayOfMonth; d.setDate(d.getDate() + 1)) {
        if (d.getDay() !== 0 && d.getDay() !== 6) workdaysInMonth++;
      }

      const presentDays = new Set();
      monthData.forEach(entry => {
        const entryDate = new Date(entry.start);
        if (entryDate.getDay() !== 0 && entryDate.getDay() !== 6) {
          presentDays.add(entryDate.toDateString());
        }
      });

      const daysPresent = presentDays.size;
      const daysAbsent = workdaysInMonth - daysPresent;

      const presentPercentage = (daysPresent / workdaysInMonth) * 100;
      const absentPercentage = (daysAbsent / workdaysInMonth) * 100;

      return {
        labels: ['Present', 'Absent'],
        datasets: [
          {
            data: [presentPercentage, absentPercentage],
            backgroundColor: ['#36A2EB', '#FF6384'],
          }
        ]
      };
    }
    onMounted(async () => {
      if (userRole.value === 'user') {
        userId.value = loggedInUserId.value
        fetchChartData()
      } else {
        await fetchUsers()
      }
    })

    return {
      isDarkTheme,
      userRole,
      inputUserId,
      userId,
      workingHoursData,
      dailyPresenceData,
      attendanceRateData,
      errorMessage,
      lineChartData,
      barChartData,
      selectedMonth,
      selectedWeek,
      selectedAttendanceMonth,
      barChartOptions,
      chartOptions,
      lineChartOptions,
      onUserIdInput,
      setUserId,
      updateBarChart,
      updateLineChart,
      updatePieChart,
      fetchChartData,
      users,
      selectedUserId,
      onUserSelect,
      setUserId,
    }
  }
}
</script>