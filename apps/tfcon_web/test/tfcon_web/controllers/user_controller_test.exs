defmodule TfconWeb.UserControllerTest do
  use TfconWeb.ConnCase

  describe "users api" do
    use Tfcon.Fixtures, [:user]
    alias Tfcon.Guardian

    test "POST /api/v1/users returns 401 for not logged in user", %{conn: conn} do
      response = conn |> get("/api/v1/users") |> json_response(401)

      assert response == %{
               "status" => "error",
               "data" => %{"errors" => ["You are not authorized."]}
             }
    end

    test "POST /api/v1/users list all users for logged in user", %{conn: conn} do
      user = user_fixture()
      {:ok, token, _} = Guardian.encode_and_sign(user)

      response =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> get("/api/v1/users")
        |> json_response(200)

      assert %{"status" => "success", "data" => data} = response
      assert [%{"account_number" => account_number, "name" => name}] = data
      assert account_number == user.account_number
      assert name == user.name
    end

    test "POST /api/v1/users/:account_number returns 401 for not logged in user", %{conn: conn} do
      response = conn |> get("/api/v1/users/1") |> json_response(401)

      assert response == %{
               "status" => "error",
               "data" => %{"errors" => ["You are not authorized."]}
             }
    end

    test "POST /api/v1/users/:account_number returns 404 for not existing account_number", %{
      conn: conn
    } do
      user = user_fixture()
      {:ok, token, _} = Guardian.encode_and_sign(user)

      response =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> get("/api/v1/users/#{404}")
        |> json_response(404)

      assert %{"status" => "error", "data" => %{"errors" => ["Entity not found."]}} = response
    end

    test "POST /api/v1/users/:account_number returns a specific user", %{conn: conn} do
      user = user_fixture()
      {:ok, token, _} = Guardian.encode_and_sign(user)

      response =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> get("/api/v1/users/#{user.account_number}")
        |> json_response(200)

      assert %{
               "data" => %{"account_number" => account_number, "name" => name},
               "status" => "success"
             } = response

      assert account_number == user.account_number
      assert name == user.name
    end
  end
end
