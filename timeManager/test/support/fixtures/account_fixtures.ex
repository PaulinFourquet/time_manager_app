defmodule TimeManager.AccountFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Account` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        username: "some username"
      })
      |> TimeManager.Account.create_user()

    user
  end

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~U[2024-10-07 08:49:00Z]
      })
      |> TimeManager.Account.create_clock()

    clock
  end

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~U[2024-10-07 08:49:00Z],
        start: ~U[2024-10-07 08:49:00Z]
      })
      |> TimeManager.Account.create_working_time()

    working_time
  end
end
