defmodule Tfcon.Guardian do
  use Guardian, otp_app: :tfcon

  alias Tfcon.Accounts

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.user_id)}
  end

  def resource_from_claims(%{"sub" => user_id}) do
    case Accounts.get_user!(user_id) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, user}
    end
  end
end
