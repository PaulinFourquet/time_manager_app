defmodule TimeManager.AccountTest do
  use TimeManager.DataCase

  alias TimeManager.Account

  describe "users" do
    alias TimeManager.Account.User

    import TimeManager.AccountFixtures

    @invalid_attrs %{username: nil, email: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{username: "some username", email: "some email"}

      assert {:ok, %User{} = user} = Account.create_user(valid_attrs)
      assert user.username == "some username"
      assert user.email == "some email"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{username: "some updated username", email: "some updated email"}

      assert {:ok, %User{} = user} = Account.update_user(user, update_attrs)
      assert user.username == "some updated username"
      assert user.email == "some updated email"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end

  describe "clocks" do
    alias TimeManager.Account.Clock

    import TimeManager.AccountFixtures

    @invalid_attrs %{status: nil, time: nil}

    test "list_clocks/0 returns all clocks" do
      clock = clock_fixture()
      assert Account.list_clocks() == [clock]
    end

    test "get_clock!/1 returns the clock with given id" do
      clock = clock_fixture()
      assert Account.get_clock!(clock.id) == clock
    end

    test "create_clock/1 with valid data creates a clock" do
      valid_attrs = %{status: true, time: ~U[2024-10-07 08:49:00Z]}

      assert {:ok, %Clock{} = clock} = Account.create_clock(valid_attrs)
      assert clock.status == true
      assert clock.time == ~U[2024-10-07 08:49:00Z]
    end

    test "create_clock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_clock(@invalid_attrs)
    end

    test "update_clock/2 with valid data updates the clock" do
      clock = clock_fixture()
      update_attrs = %{status: false, time: ~U[2024-10-08 08:49:00Z]}

      assert {:ok, %Clock{} = clock} = Account.update_clock(clock, update_attrs)
      assert clock.status == false
      assert clock.time == ~U[2024-10-08 08:49:00Z]
    end

    test "update_clock/2 with invalid data returns error changeset" do
      clock = clock_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_clock(clock, @invalid_attrs)
      assert clock == Account.get_clock!(clock.id)
    end

    test "delete_clock/1 deletes the clock" do
      clock = clock_fixture()
      assert {:ok, %Clock{}} = Account.delete_clock(clock)
      assert_raise Ecto.NoResultsError, fn -> Account.get_clock!(clock.id) end
    end

    test "change_clock/1 returns a clock changeset" do
      clock = clock_fixture()
      assert %Ecto.Changeset{} = Account.change_clock(clock)
    end
  end

  describe "workingtime" do
    alias TimeManager.Account.WorkingTime

    import TimeManager.AccountFixtures

    @invalid_attrs %{start: nil, end: nil}

    test "list_workingtimes/0 returns all workingtime" do
      working_time = working_time_fixture()
      assert Account.list_workingtimes() == [working_time]
    end

    test "get_working_time!/1 returns the working_time with given id" do
      working_time = working_time_fixture()
      assert Account.get_working_time!(working_time.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time" do
      valid_attrs = %{start: ~U[2024-10-07 08:49:00Z], end: ~U[2024-10-07 08:49:00Z]}

      assert {:ok, %WorkingTime{} = working_time} = Account.create_working_time(valid_attrs)
      assert working_time.start == ~U[2024-10-07 08:49:00Z]
      assert working_time.end == ~U[2024-10-07 08:49:00Z]
    end

    test "create_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_working_time(@invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time" do
      working_time = working_time_fixture()
      update_attrs = %{start: ~U[2024-10-08 08:49:00Z], end: ~U[2024-10-08 08:49:00Z]}

      assert {:ok, %WorkingTime{} = working_time} = Account.update_working_time(working_time, update_attrs)
      assert working_time.start == ~U[2024-10-08 08:49:00Z]
      assert working_time.end == ~U[2024-10-08 08:49:00Z]
    end

    test "update_working_time/2 with invalid data returns error changeset" do
      working_time = working_time_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_working_time(working_time, @invalid_attrs)
      assert working_time == Account.get_working_time!(working_time.id)
    end

    test "delete_working_time/1 deletes the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{}} = Account.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> Account.get_working_time!(working_time.id) end
    end

    test "change_working_time/1 returns a working_time changeset" do
      working_time = working_time_fixture()
      assert %Ecto.Changeset{} = Account.change_working_time(working_time)
    end
  end
end
