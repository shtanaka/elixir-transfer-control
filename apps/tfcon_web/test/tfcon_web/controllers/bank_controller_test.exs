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

    test "POST /api/v1/bank/transfer successfully transfers money from one account to another", %{
      conn: conn
    } do
      from = user_fixture()
      to = second_user_fixture()
      {:ok, token, _} = Guardian.encode_and_sign(from)
      request_data = %{account_number: to.account_number, amount: 600}

      transfer_message =
        "value successfully transfered from #{from.account_number} to #{to.account_number}."

      response =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> post("/api/v1/bank/transfer", request_data)
        |> json_response(200)

      assert %{"status" => "success", "data" => data} = response
      assert data["from"]["account_number"] == from.account_number
      assert data["to"]["account_number"] == to.account_number
      assert data["message"] == transfer_message
    end

    test "POST /api/v1/bank/transfer does not transfer if value is above user balance", %{
      conn: conn
    } do
      from = user_fixture()
      to = second_user_fixture()
      {:ok, token, _} = Guardian.encode_and_sign(from)
      request_data = %{account_number: to.account_number, amount: 1100}

      response =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> post("/api/v1/bank/transfer", request_data)
        |> json_response(400)

      assert %{
               "status" => "error",
               "data" => %{"errors" => %{"balance" => ["Not enough balance"]}}
             } = response
    end
  end
end
