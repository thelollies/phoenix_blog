defmodule Blog.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title,        :text
      add :display_date, :date
      add :publish_at,   :date
      add :content,      :text
      add :markdown,     :text
      add :category,     :text

      timestamps
    end

  end
end
