defmodule TfconWeb.BankController do
  use TfconWeb, :controller
  use PhoenixSwagger

  alias Tfcon.{Accounts, Bank}

  def my_account(%{private: %{guardian_default_resource: user}} = conn, _) do
    render(conn, "my_account.json", %{user: user})
  end

  swagger_path :my_account do
    get("/api/v1/bank/my_account")
    summary("Get logged in account information")
    response(200, "Ok", Schema.ref(:MyAccountResponse))
  end

  def transfer(%{private: %{guardian_default_resource: from}} = conn, %{
        "account_number" => account_number,
        "amount" => amount
      }) do
    to = Accounts.get_user_by_account_number!(account_number)
    do_transfer(conn, from, to, amount)
  end

  swagger_path :transfer do
    post("/api/v1/bank/transfer")
    summary("Transfer endpoint")
    description("Transfers money from one account to another")

    parameters do
      transfer(:body, Schema.ref(:Transfer), "Transfer")
    end

    response(200, "Ok", Schema.ref(:TransferResponse))
  end

  defp do_transfer(conn, _, nil, _),
    do: conn |> put_status(404) |> render("404.json", %{user: nil})
  defp do_transfer(conn, from, to, amount) do
    do_transfer(conn, Bank.transfer(from, to, amount))
  end
  defp do_transfer(conn, {:error, :from, changeset, %{}}),
    do: conn |> put_status(400) |> render("no_balance.json", %{changeset: changeset})
  defp do_transfer(conn, {:error, :no_self_transfer}),
    do: conn |> put_status(400) |> render("no_self_transfer.json")
  defp do_transfer(conn, {:ok, %{from: _, to: _} = transfer_data}) do
    render(conn, "transfer.json", transfer_data)
  end

  def withdraw(%{private: %{guardian_default_resource: from}} = conn, %{"amount" => amount}) do
    do_withdraw(conn, from, amount)
  end

  swagger_path :withdraw do
    post("/api/v1/bank/withdraw")
    summary("withdraw endpoint")
    description("Withdraws money from logged in account")

    parameters do
      withdraw(:body, Schema.ref(:Withdraw), "Withdraw")
    end

    response(200, "Ok", Schema.ref(:WithdrawResponse))
  end

  defp do_withdraw(conn, from, amount) do
    do_withdraw(conn, Bank.withdraw(from, amount))
  end
  defp do_withdraw(conn, {:error, changeset}),
    do: conn |> put_status(400) |> render("no_balance.json", %{changeset: changeset})
  defp do_withdraw(conn, {:ok, user}) do
    render(conn, "withdraw.json", %{user: user})
  end

  def swagger_definitions do
    %{
      MyAccountResponse:
        swagger_schema do
          title("My Account Response")
          description("My Account Response")

          properties do
            account_number(:integer, "", required: true)
            balance(:float, "", required: true)
            name(:string, "", required: true)
          end

          example(%{
            account_number: 1,
            balance: 1000,
            name: "Jonh Doe"
          })
        end,
      TransferResponse:
        swagger_schema do
          title("Transfer Response")
          description("Transfer Response")

          properties do
            from(
              Schema.new do
                properties do
                  account_number(:integer, "", required: true)
                  balance(:float, "", required: true)
                  name(:string, "", required: true)
                end
              end
            )

            to(
              Schema.new do
                properties do
                  account_number(:integer, "", required: true)
                  name(:string, "", required: true)
                end
              end
            )

            message(:string, "", required: true)
          end

          example(%{
            from: %{
              account_number: 1,
              balance: 970.0,
              name: "Arrowers The Second"
            },
            message: "value successfully transfered from 1 to 2.",
            to: %{
              account_number: 2,
              name: "Arrowers The Second"
            }
          })
        end,
      Transfer:
        swagger_schema do
          title("Transfer")
          description("Transfer request body")

          properties do
            account_number(:integer, "", required: true)
            amount(:float, "", required: true)
          end

          example(%{
            account_number: 1,
            amount: 30.5
          })
        end,
      WithdrawResponse:
        swagger_schema do
          title("Withdraw Response")
          description("Withdraw Response")

          properties do
            user(
              Schema.new do
                properties do
                  account_number(:integer, "", required: true)
                  balance(:float, "", required: true)
                  name(:string, "", required: true)
                end
              end
            )

            message(:string, "", required: true)
          end

          example(%{
            user: %{
              account_number: 1,
              balance: 970.0,
              name: "Arrowers The Second"
            },
            message: "value successfully debited from 1.",

          })
        end,
      Withdraw:
        swagger_schema do
          title("Withdraw")
          description("Withdraw request body")

          properties do
            amount(:float, "", required: true)
          end

          example(%{
            amount: 30.5
          })
        end
    }
  end
end
