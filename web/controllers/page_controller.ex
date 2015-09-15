defmodule Blog.PageController do
  use Blog.Web, :controller

  def index(conn, _params) do
    render conn, to: Blog.Router.Helpers.post_path(conn, :index)
  end
end
