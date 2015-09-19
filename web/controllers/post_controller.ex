defmodule Blog.PostController do
  use Blog.Web, :controller

  alias Blog.Post

  plug :scrub_params, "post" when action in [:create, :update]

  def index(conn, _params) do
    base_query = from p in Post,
     select: p

    full_query = case _params["category"] do
      "slack" ->
        from p in base_query,
        where: p.category == "slack"
      "code"  ->
        from p in base_query,
        where: p.category == "code"
      _ ->
          base_query
    end

    posts = Repo.all(full_query)
    render(conn, "index.html", posts: posts)
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
    post = Repo.get!(Post, id)
    # TODO prevent show of unpublished
    # output = Path.join("posts", post.file)
    #   |> File.read!
    #   |> Earmark.to_html
    put_layout(conn, "app.html")
      |> render "show.html", post: post
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
end
