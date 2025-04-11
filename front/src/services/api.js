import axios from 'axios'

const apiClient = axios.create({
  baseURL: 'http://localhost:4000/api/',
  headers: {
    'Content-Type': 'application/json'
  },
  withCredentials: true
})

export default {
  // Users
  listUsers(params = {}) {
    return apiClient.get('users', { params })
  },
  createUser(userData) {
    return apiClient.post('users', userData)
  },
  updateUser(id, userData) {
    return apiClient.put(`users/${id}`, userData)
  },
  deleteUser(id) {
    return apiClient.delete(`users/${id}`)
  },

  // Authentification
  login(email, password) {
    return apiClient.post('login', { email, password })
  },
  register(username, email, password) {
    return apiClient.post('users', { username, email, password })
  },
  logout() {
    return apiClient.post('logout')
  },

  // WorkingTime
  createWT(userId, workingTime) {
    return apiClient.post(`workingtime/${userId}`, workingTime)
  },
  getWorkingTime(userId) {
    return apiClient.get(`workingtime/${userId}`)
  },
  getWorkingTimeByUserAndId(userId, workingTimeId) {
    return apiClient.get(`workingtime/${userId}/${workingTimeId}`)
  },
  updateWT(workingTimeId, workingTime) {
    return apiClient.put(`workingtime/${workingTimeId}`, workingTime)
  },
  deleteWT(workingTimeId) {
    return apiClient.delete(`workingtime/${workingTimeId}`)
  },

  // WorkingTimes
  getWorkingTimes() {
    return apiClient.get('/workingtime')
  },
  getWorkingTimesByUser(userId) {
    return apiClient.get(`/workingtime/${userId}`)
  },

  // Clocks
  getClocks(userId) {
    return apiClient.get(`clocks/${userId}`)
  },
  postClock(userId, time, status) {
    return apiClient.post(`clocks/${userId}`, {
      time: time,
      status: status.toString()
    })
  },

  // Roles
  listRoles() {
    return apiClient.get('role')
  },
  createRole(roleData) {
    return apiClient.post('role', roleData)
  },
  deleteRole(id) {
    return apiClient.delete(`role/${id}`)
  },
  assignRoleToUser(userId, roleId) {
    return apiClient.post(`user_roles/${userId}/${roleId}`)
  },

  // User Roles
  getUserRoles(userId) {
    return apiClient.get(`user_roles/${userId}`)
  }
}
