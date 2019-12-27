defmodule TfconWeb.AuthControllerTest do
  use TfconWeb.ConnCase

  describe "auth api" do
    @invalid_password "asappp"
    use Tfcon.Fixtures, [:user]

    test "POST /api/v1/auth returns valid token for valid account number and password", %{conn: conn} do
      user = user_fixture()

      request_data = %{account_number: user.account_number, password: @valid_password}

      response =
        conn
        |> post("/api/v1/auth", request_data)
        |> json_response(200)

      assert %{"token" => token} = response
    end

    test "POST /api/v1/auth returns error for invalid fields", %{conn: conn} do
      user = user_fixture()

      request_data = %{account_number: user.account_number, password: @invalid_password}

      response =
        conn
        |> post("/api/v1/auth", request_data)
        |> json_response(401)

      assert %{"errors" => ["Invalid credentials"]} = response
    end
  end

end
