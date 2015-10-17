defmodule Blog.PostController do
  use Blog.Web, :controller

  alias Blog.Post

  plug Blog.Plug.Authenticate when not action in [ :index, :show ]
  plug :scrub_params, "post" when action in [:create, :update]

  def index(conn, _params) do

    user = get_session( conn, :current_user )

    base_query = if user do
      from p in Post,
      order_by: p.display_date,
      select: p
    else
      from p in Post,
      where: p.publish_at <= ^Ecto.Date.utc,
      order_by: p.display_date,
      select: p
    end

    posts = Repo.all(base_query)
    render(conn, "index.html", posts: posts, user: user)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do

    changeset = Post.changeset(%Post{}, process_markdown( post_params ))

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: post_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do

    # Check the id is numerical (otherwise Ecto will complain).
    case Integer.parse( id ) do
      { post_id , ""} ->

        query = from p in Blog.Post, where: p.id == ^post_id

        # Hide unpublished articles from unauthenticated users.
        user = get_session( conn, :current_user )
        if user == nil do
          query = from p in query, where: p.publish_at <= ^Ecto.Date.utc
        end

        case Repo.one( query ) do
          nil ->
            # No such post
            conn |> show_404
          post ->
            put_layout( conn, "app.html" )
            |> render "show.html", post: post, user: user
        end

      _ -> false
        # Not a numerical id.
        conn |> show_404
    end
  end

  def edit(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post, process_markdown( post_params ))

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end

  defp process_markdown( params ) do
    markdown = Dict.get( params, "markdown" )
    content = Earmark.to_html( markdown )
    Dict.put( params, "content", content )
  end

  defp show_404( conn ) do
    conn
    |> put_status(:not_found)
    |> render(Blog.ErrorView, "404.html")
  end
end
