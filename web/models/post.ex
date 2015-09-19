defmodule Blog.Post do
  use Blog.Web, :model

  schema "posts" do
    field :title,        :string
    field :display_date, Ecto.Date
    field :publish_at,   Ecto.Date
    field :content,      :string
    field :markdown,     :string
    field :category,     :string

    timestamps
  end

  @required_fields ~w( title markdown category )
  @optional_fields ~w( content display_date publish_at)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
