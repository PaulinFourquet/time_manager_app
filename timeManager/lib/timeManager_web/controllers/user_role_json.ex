defmodule TimeManagerWeb.UserRoleJSON do
  alias TimeManager.Account.UserRole
  @doc """
  Renders a list of user roles.
  """
  def index(%{user_roles: user_roles}) do
    %{data: for(user_role <- user_roles, do: data(user_role))}
  end
  defp data(%UserRole{} = user_role) do
    %{
      user_id: user_role.user_id,
      role_id: user_role.role_id,
      role_name: user_role.role.name,
      assigned_at: user_role.assigned_at
    }
  end
end
