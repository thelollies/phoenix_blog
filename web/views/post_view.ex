defmodule Blog.PostView do
  use Blog.Web, :view

  def get_date(date) do
    Ecto.Date.to_string date
  end
end
