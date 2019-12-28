defmodule TfconWeb.BankControllerTest do
  use TfconWeb.ConnCase

  describe "bank api" do
    use Tfcon.Fixtures, [:user]
    alias Tfcon.Guardian

    test "GET /api/v1/bank/my_account returns 401 for not logged in user", %{conn: conn} do
      response = conn |> get("/api/v1/bank/my_account") |> json_response(401)

      assert response == %{
               "status" => "error",
               "data" => %{"errors" => ["You are not authorized."]}
             }
    end

    test "GET /api/v1/bank/my_account list all users for logged in user", %{conn: conn} do
      user = user_fixture()
      {:ok, token, _} = Guardian.encode_and_sign(user)

      response =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> get("/api/v1/bank/my_account")
        |> json_response(200)

      assert %{"status" => "success", "data" => data} = response

      assert %{
               "user" => %{
                 "account_number" => account_number,
                 "name" => name,
                 "balance" => 1000.0
               }
             } = data

      assert account_number == user.account_number
      assert name == user.name
    end
  end
end
