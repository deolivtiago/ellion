defmodule EllionCore.Accounts.UserEmails do
  import Swoosh.Email

  alias EllionCore.Accounts.Users.User
  alias EllionCore.Mailer

  @instruction_types ~w(confirm_email reset_password change_email)a

  def send_instructions(type, %User{} = user, url) when type in @instruction_types do
    type
    |> get_instructions(first_name(user), url)
    |> deliver(user.email)
  end

  defp deliver(content, recipient) do
    email =
      new()
      |> to(recipient)
      |> from({"Ellion", "ellion@clarx.io"})
      |> subject(content.subject)
      |> text_body(content.text_body)

    with {:ok, _meta} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  defp first_name(%User{full_name: full_name}), do: String.split(full_name) |> List.first()

  defp get_instructions(:confirm_email, name, url) do
    %{
      subject: "Confirm email instructions",
      text_body: """

      ==============================

      Hi #{name},

      You can confirm your account by visiting the URL below:

      #{url}

      If you didn't create an account with us, please ignore this.

      ==============================
      """
    }
  end

  defp get_instructions(:reset_password, name, url) do
    %{
      subject: "Reset password instructions",
      text_body: """

      ==============================

      Hi #{name},

      You can reset your password by visiting the URL below:

      #{url}

      If you didn't request this change, please ignore this.

      ==============================
      """
    }
  end

  defp get_instructions(:change_email, name, url) do
    %{
      subject: "Update email instructions",
      text_body: """

      ==============================

      Hi #{name},

      You can change your email by visiting the URL below:

      #{url}

      If you didn't request this change, please ignore this.

      ==============================
      """
    }
  end
end
