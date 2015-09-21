defmodule Blog.SessionController do
  use Blog.Web, :controller

  alias Blog.User

  plug :scrub_params, "user" when action in [ :create ]

  def new( conn, _params ) do
    render conn, changeset: User.changeset( %User{} )
  end

  def create( conn, params ) do

    user_params = params[ "user" ]

    # Produce :ok or :error
    verified = Recaptcha.verify(conn.remote_ip, params["g-recaptcha-response"])

    if verified == :error do
      conn
      |> put_flash( :error, 'Failed reCAPTCHA, try again.' )
      |> render "new.html", changeset: User.changeset( %User{} )
    else
      user = if is_nil( user_params[ "username" ] ) do
        nil
      else
        Repo.get_by( User, username: user_params[ "username" ] )
      end

      user
      |> sign_in( user_params[ "password" ], conn )
    end

  end

  def delete( conn, _ ) do
    delete_session( conn, :current_user )
      |> put_flash( :info, 'You have been logged out' )
      |> redirect( to: session_path( conn, :new ) )
  end

  defp sign_in( user, password, conn ) when is_nil( user ) do
    conn
      |> put_flash( :error, 'Username or password are incorrect.' )
      |> render "new.html", changeset: User.changeset( %User{} )
  end

  defp sign_in( user, password, conn ) when is_map( user ) do
    cond do
      Comeonin.Bcrypt.checkpw( password, user.encrypted_password ) ->
        conn
          |> put_session( :current_user, Map.take( user, [ :id, :username, :role ] ) )
          |> put_flash( :info, 'You are now signed in.' )
          |> redirect( to: post_path( conn, :index ) )
      true ->
        conn
          |> put_flash( :error, 'Username or password are incorrect.' )
          |> render "new.html", changeset: User.changeset( %User{} )

    end
  end
end
