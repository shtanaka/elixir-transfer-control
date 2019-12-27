defmodule TfconWeb.PageControllerTest do
  use TfconWeb.ConnCase

  alias TfconWeb.UserSerializers

  describe "auth api" do
    @invalid_password "asappp"
    use Tfcon.Fixtures, [:user]

    test "POST /api/v1/users list all users", %{conn: conn} do
      user = user_fixture()

      request_data = %{account_number: user.account_number, password: @valid_password}

      response =
        conn
        |> post("/api/v1/auth", request_data)
        |> json_response(200)

      assert %{"token" => token} = response
    end
  end
end
