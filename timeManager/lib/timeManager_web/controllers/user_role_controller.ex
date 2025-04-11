defmodule TimeManagerWeb.UserRoleController do
  use TimeManagerWeb, :controller
  alias TimeManager.Account
  action_fallback TimeManagerWeb.FallbackController
  def assign_role(conn, %{"user_id" => user_id, "role_id" => role_id}) do
    with {:ok, _user_role} <- Account.assign_role_to_user(user_id, role_id) do
      send_resp(conn, :created, "")
    end
  end
  def get_user_roles(conn, %{"user_id" => user_id}) do
    user_roles = Account.get_user_roles(user_id)
    render(conn, :index, user_roles: user_roles)
  end
  def update_user_role(conn, %{"user_id" => user_id, "old_role_id" => old_role_id, "new_role_id" => new_role_id}) do
    {updated, _} = Account.update_user_role(user_id, old_role_id, new_role_id)
    if updated > 0 do
      send_resp(conn, :ok, "")
    else
      send_resp(conn, :not_found, "")
    end
  end
  def remove_user_role(conn, %{"user_id" => user_id, "role_id" => role_id}) do
    {deleted, _} = Account.remove_user_role(user_id, role_id)
    if deleted > 0 do
      send_resp(conn, :no_content, "")
    else
      send_resp(conn, :not_found, "")
    end
  end
end
