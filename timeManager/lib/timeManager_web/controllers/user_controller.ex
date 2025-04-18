defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Account
  alias TimeManager.Account.User

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    users = Account.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"username" => username, "email" => email, "password" => password}) do
    user_params = %{username: username, email: email, password: password}

      with {:ok, %User{} = user} <- Account.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "username" => username, "email" => email, "password" => password}) do
    user = Account.get_user!(id)
    user_params = %{"username" => username, "email" => email, "password" => password}

    with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Account.get_user!(id)

    with {:ok, %User{}} <- Account.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
