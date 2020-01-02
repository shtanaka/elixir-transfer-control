defmodule TfconWeb.UserController do
  use TfconWeb, :controller
  use PhoenixSwagger

  alias Tfcon.{Accounts, Guardian}

  def index(conn, _) do
    render(conn, "index.json", %{users: Accounts.list_users()})
  end

  swagger_path :index do
    get("/api/v1/users")
    summary("Get list of users")
    response(200, "Ok", Schema.ref(:ListUsersResponse))
  end

  def show(conn, %{"account_number" => account_number}) do
    {account_number, _} = Integer.parse(account_number)
    user = Accounts.get_user_by_account_number!(account_number)

    render_show(conn, user)
  end

  defp render_show(conn, nil), do: conn |> put_status(404) |> render("404.json", %{user: nil})
  defp render_show(conn, user), do: conn |> render("show.json", %{user: user})

  def create(conn, %{"name" => name, "password" => password}) do
    create_data = Accounts.create_user(%{name: name, password: password})

    render_create(conn, create_data)
  end

  swagger_path :create do
    post("/api/v1/users")
    summary("Create a new user")
    parameters do
      create_user_data(:body, Schema.ref(:CreateUser), "Create user")
    end
    response(200, "Ok", Schema.ref(:CreateUserResponse))
  end

  defp render_create(conn, {:ok, user}) do
    {:ok, token, _} = Guardian.encode_and_sign(user)
    conn |> render("create.json", %{user: user, token: token})
  end

  defp render_create(conn, {:error, changeset}),
    do: conn |> put_status(400) |> render("400.json", %{changeset: changeset})

  def swagger_definitions do
    %{
      User:
        swagger_schema do
          title "User"
          description "Main user authentication entity"
          properties do
            account_number :integer, "", required: true
            name :string, "", required: true
          end
        end,
      ListUsersResponse:
        swagger_schema do
          title("User list response")
          description("User list response")
          type :array

          items Schema.ref(:User)
        end,
      CreateUser: swagger_schema do
        title("Create user")
        description("Create user")

        properties do
          name :string, "", required: true
          password :string, "", required: true
        end

        example(%{
          name: "Jonh Doe",
          password: "my password",
        })
      end,
      CreateUserResponse:
        swagger_schema do
          title "Create user Response"
          description "Create user response"
          properties do
            token :string, "", required: true
            user Schema.ref(:User)
          end
        end
    }
  end
end
