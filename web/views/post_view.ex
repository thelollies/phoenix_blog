defmodule Blog.PostView do
  use Blog.Web, :view

  def get_date(date) do
    Ecto.Date.to_string date
  end

  def is_published?( post ) do
    post.publish_at <= Ecto.Date.utc
  end
end
