defmodule TimeManagerWeb.ClockControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.AccountFixtures

  alias TimeManager.Account.Clock

  @create_attrs %{
    status: true,
    time: ~U[2024-10-07 08:49:00Z]
  }
  @update_attrs %{
    status: false,
    time: ~U[2024-10-08 08:49:00Z]
  }
  @invalid_attrs %{status: nil, time: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all clocks", %{conn: conn} do
      conn = get(conn, ~p"/api/clocks")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create clock" do
    test "renders clock when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/clocks", clock: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/clocks/#{id}")

      assert %{
               "id" => ^id,
               "status" => true,
               "time" => "2024-10-07T08:49:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/clocks", clock: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update clock" do
    setup [:create_clock]

    test "renders clock when data is valid", %{conn: conn, clock: %Clock{id: id} = clock} do
      conn = put(conn, ~p"/api/clocks/#{clock}", clock: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/clocks/#{id}")

      assert %{
               "id" => ^id,
               "status" => false,
               "time" => "2024-10-08T08:49:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, clock: clock} do
      conn = put(conn, ~p"/api/clocks/#{clock}", clock: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete clock" do
    setup [:create_clock]

    test "deletes chosen clock", %{conn: conn, clock: clock} do
      conn = delete(conn, ~p"/api/clocks/#{clock}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/clocks/#{clock}")
      end
    end
  end

  defp create_clock(_) do
    clock = clock_fixture()
    %{clock: clock}
  end
end
