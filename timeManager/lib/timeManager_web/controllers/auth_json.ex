defmodule TimeManagerWeb.AuthJSON do
  def login(%{user: user, token: token}) do
    %{
      data: %{
        user: %{
          id: user.id,
          email: user.email,
          username: user.username
        },
        token: token
      }
    }
  end
end
