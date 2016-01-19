defmodule Blog.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comment) do
      add :body, :string
      add :post_id, :uuid

      timestamps
    end

  end
end
