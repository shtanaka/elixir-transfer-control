defmodule TfconWeb.AuthController do
  use TfconWeb, :controller
  use PhoenixSwagger

  alias Tfcon.{Accounts, Guardian}
  alias Tfcon.JsonHandler

  def create(conn, %{"account_number" => account_number, "password" => password}) do
    auth_data = Accounts.authenticate_user(account_number, password)
    login_reply(conn, auth_data)
  end

  swagger_path :create do
    post "/api/v1/auth"
    summary "get auth data"
    description "get auth data"
    parameters do
      login_credentials :body, Schema.ref(:Auth), "Login credentials"
    end
    response 200, "Ok", Schema.ref(:AuthResponse)
  end

  defp login_reply(conn, {:ok, user}) do
    {:ok, token, _} = Guardian.encode_and_sign(user)
    json(conn, JsonHandler.success_json(%{token: token}))
  end
  defp login_reply(conn, {:error, reason}) do
    conn
    |> put_status(401)
    |> json(JsonHandler.error_json(%{errors: [reason]}))
  end

  def swagger_definitions do
    %{
      Auth: swagger_schema do
        title "Authentication Response"
        description "Authentication Response of application"
        properties do
          account_number :integer, "", required: true
          password :string, "", required: true
        end
        example %{
          account_number: 1,
          password:  "mypassword"
        }
      end,
      AuthResponse: swagger_schema do
        title "Authentication"
        description "Authentication of application"
        properties do
          token :string, "", required: true
        end
        example %{token: "token"}
      end
    }
  end
end
