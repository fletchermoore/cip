defmodule Cip.Mail.Email do
  use Bamboo.Phoenix, view: CipWeb.EmailView


  def invite_email(conn, user, password) do
    basic_email()
    |> to(user.email)
    |> subject("Invitation to Participate")
    |> render(:invite, password: password, conn: conn)
  end

  def reset_pw(conn, user, password) do
    basic_email()
    |> to(user.email)
    |> subject("Password Reset")
    |> render(:reset, password: password, conn: conn)
  end
  #
  # # def forgot_password(conn, name, to_email, password) do
  # #   basic_email
  # #   |> to(to_email)
  # #   |> subject("You have requested a password reset")
  # #   |> render(:forgot_password, name: name, password: password, conn: conn)
  # # end
  #
  defp basic_email do
    new_email()
    |> from("no-reply@#{System.get_env("URL_DOMAIN")}")
    # |> put_html_layout({Drmom.LayoutView, "email.html"})
  end
end
