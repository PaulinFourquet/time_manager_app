defmodule TimeManager.Repo.Migrations.CreateWorkingtimes do
  use Ecto.Migration

  def change do
    create table(:workingtime) do
      add :start, :utc_datetime
      add :end, :utc_datetime
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:workingtime, [:user_id])
  end
end
