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
    output = Path.join("posts", post.file)
      |> File.read!
      |> Earmark.to_html
    put_layout(conn, "post.html")
      |> render "show.html", post: post, output: output
  end

end
