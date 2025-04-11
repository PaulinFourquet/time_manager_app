defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Account
  alias TimeManager.Account.WorkingTime

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    workingtime = Account.list_workingtimes()
    render(conn, :index, working_time: workingtime)
  end

  def listByUserId(conn, %{"user_id" => user_id}) do
    workingtime = Account.list_workingtimes_by_user_id(user_id)
    render(conn, "index.json", working_time: workingtime)
  end


  def create(conn, %{"user_id" => user_id} = params) do
    working_time_params = Map.put(params, "user_id", user_id)

    with {:ok, %WorkingTime{} = working_time} <- Account.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtime/#{working_time.id}")
      |> render(:show, working_time: working_time)
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(TimeManagerWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    working_time = Account.get_working_time_by_user!(user_id, id)
    render(conn, :show, working_time: working_time)
  end

  @spec update(any(), map()) :: any()
  def update(conn, %{"id" => id, "start" => start, "end" => end_time}) do
    working_time = Account.get_working_time!(id)
    working_time_params = %{"start" => start, "end" => end_time}

    with {:ok, %WorkingTime{} = working_time} <- Account.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = Account.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Account.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
