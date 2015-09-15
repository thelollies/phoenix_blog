defmodule Blog.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :file, :string
      add :basename, :string
      add :date, :date

      timestamps
    end

  end
end
