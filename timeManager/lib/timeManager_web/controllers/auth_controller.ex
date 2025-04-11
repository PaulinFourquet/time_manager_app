defmodule TimeManagerWeb.AuthController do
  use TimeManagerWeb, :controller

  alias TimeManager.Account
  alias TimeManager.Guardian

  def login(conn, %{"email" => email, "password" => password}) do
    case Account.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        conn
        |> put_status(:ok)
        |> render("login.json", user: user, token: token)
      {:error, :invalid_credentials} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})
    end
  end

  def logout(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_status(:ok)
    |> json(%{message: "Logged out successfully"})
  end
end
