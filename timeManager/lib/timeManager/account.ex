defmodule TimeManager.Account do
  import Ecto.Query, warn: false
  alias TimeManager.Repo
  alias Pbkdf2

  alias TimeManager.Account.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def authenticate_user(email, password) do
    query = from(u in User, where: u.email == ^email)
    case Repo.one(query) do
      nil ->
        Pbkdf2.no_user_verify()
        {:error, :invalid_credentials}
      user ->
        if Pbkdf2.verify_pass(password, user.password_hash) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  alias TimeManager.Account.Clock

  def list_clocks do
    Repo.all(Clock)
  end

  def get_clock!(id), do: Repo.get!(Clock, id)

  def create_clock(attrs \\ %{}) do
    %Clock{}
    |> Clock.changeset(attrs)
    |> Repo.insert()
  end

  def list_clocks_by_user_id(user_id) do
    Repo.all(from c in Clock, where: c.user_id == ^user_id)
  end

  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  def delete_clock(%Clock{} = clock) do
    Repo.delete(clock)
  end

  def change_clock(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end

  alias TimeManager.Account.WorkingTime

  def list_workingtimes do
    Repo.all(WorkingTime)
  end

  def get_working_time_by_user!(user_id, id) do
    Repo.get_by!(WorkingTime, user_id: user_id, id: id)
  end

  def get_working_time!(id), do: Repo.get!(WorkingTime, id)

  def create_working_time(attrs \\ %{}) do
    %WorkingTime{}
    |> WorkingTime.changeset(attrs)
    |> Repo.insert()
  end

  def update_working_time(%WorkingTime{} = working_time, attrs) do
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end

  def list_workingtimes_by_user_id(user_id) do
    Repo.all(from wt in WorkingTime, where: wt.user_id == ^user_id)
  end

  def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
    WorkingTime.changeset(working_time, attrs)
  end

  # Role
  alias TimeManager.Account.Role

  def list_roles do
    Repo.all(Role)
  end

  def get_role!(id), do: Repo.get!(Role, id)

  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  def delete_role(%Role{} = role) do
    Repo.delete(role)
  end

  # User Role
  alias TimeManager.Account.UserRole

  def assign_role_to_user(user_id, role_id) do
    %UserRole{}
    |> UserRole.changeset(%{user_id: user_id, role_id: role_id, assigned_at: DateTime.utc_now()})
    |> Repo.insert()
  end

  def get_user_roles(user_id) do
    Repo.all(from ur in UserRole, where: ur.user_id == ^user_id, preload: :role)
  end

  def update_user_role(user_id, old_role_id, new_role_id) do
    from(ur in UserRole, where: ur.user_id == ^user_id and ur.role_id == ^old_role_id)
    |> Repo.update_all(set: [role_id: new_role_id, assigned_at: DateTime.utc_now()])
  end

  def remove_user_role(user_id, role_id) do
    from(ur in UserRole, where: ur.user_id == ^user_id and ur.role_id == ^role_id)
    |> Repo.delete_all()
  end
end
