defmodule Blog.PostController do
  use Blog.Web, :controller

  alias Blog.Post

  plug :scrub_params, "post" when action in [:create, :update]

  def index(conn, _params) do
    posts = Repo.all(Post)
    render(conn, "index.html", posts: posts)
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

  def new(conn, _params) do
    render( conn, "new.html")
  end
end
