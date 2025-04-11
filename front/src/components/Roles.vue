<template>
<div class="xl:ml-4">
    <div :class="[isDarkTheme ? 'bg-InputBgGray text-white shadow-none' : 'bg-white text-black', 'h-auto rounded-3xl shadow-lg shadow-gray-400/90 p-2 xl:mt-4 mb-4']">
        <div className="xl:ml-20">
            <div class="role-component p-5">
                <div class="mb-6">
                    <h3 class="text-lg font-semibold mb-2">Create Role</h3>
                    <form @submit.prevent="createRole" class="flex flex-col space-y-2">
                        <input v-model="newRole.name" placeholder="Role Name" class="border p-2 rounded" required>
                        <input v-model="newRole.description" placeholder="Role Description" class="border p-2 rounded">
                        <button type="submit" class="bg-blue-500 p-2 rounded">Create Role</button>
                    </form>
                </div>
            
                <div class="mb-6">
                    <h3 class="text-lg font-semibold mb-2">Roles</h3>
                    <ul class="space-y-2">
                    <li v-for="role in roles" :key="role.id" class="flex justify-between items-center">
                        <span>{{ role.name }}</span>
                        <button @click="deleteRole(role.id)" class="bg-red-500 p-1 rounded">Delete</button>
                    </li>
                    </ul>
                </div>
            
                <div>
                    <h3 class="text-lg font-semibold mb-2">Assign Role to User</h3>
                    <form @submit.prevent="assignRole" class="flex flex-col space-y-2">
                    <select v-model="assignRoleForm.userId" class="border p-2 rounded" required>
                        <option value="">Select User</option>
                        <option v-for="user in users" :key="user.id" :value="user.id">{{ user.username }}</option>
                    </select>
                    <select v-model="assignRoleForm.roleId" class="border p-2 rounded" required>
                        <option value="">Select Role</option>
                        <option v-for="role in roles" :key="role.id" :value="role.id">{{ role.name }}</option>
                    </select>
                    <button type="submit" class="bg-green-500 p-2 rounded">Assign Role</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</template>
  
<script>
import api from '@/services/api'
import { useTheme } from '@/composables/useTheme'

export default {
    name: 'Role',
    setup() {
        const { isDarkTheme } = useTheme()

        return {
            isDarkTheme
        }
    },
    data() {
        return {
            newRole: {
                name: '',
                description: ''
            },
            roles: [],
            users: [],
            assignRoleForm: {
                userId: '',
                roleId: ''
            }
        }
    },
    async created() {
        try {
            const [usersResponse, rolesResponse] = await Promise.all([
                api.listUsers(),
                api.listRoles()
            ]);
            this.users = usersResponse.data.data;
            this.roles = rolesResponse.data.data;
        } catch (error) {
            console.error('Failed to fetch data:', error);
        }
    },
    methods: {
        async createRole() {
            try {
                await api.createRole(this.newRole);
                this.newRole = { name: '', description: '' };
                await this.fetchRoles();
            } catch (error) {
                console.error('Error creating role:', error);
            }
        },
        async deleteRole(roleId) {
            try {
                await api.deleteRole(roleId);
                await this.fetchRoles();
            } catch (error) {
                console.error('Error deleting role:', error);
            }
        },
        async assignRole() {
            try {
                await api.assignRoleToUser(this.assignRoleForm.userId, this.assignRoleForm.roleId);
                this.assignRoleForm = { userId: '', roleId: '' };
            } catch (error) {
                console.error('Error assigning role:', error);
            }
        },
        async fetchRoles() {
            try {
                const response = await api.listRoles();
                this.roles = response.data.data;
            } catch (error) {
                console.error('Error fetching roles:', error);
            }
        }
    }
}
</script>