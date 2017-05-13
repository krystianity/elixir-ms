defmodule ExTest.Repos.Test.Migrations.AddTestTable do
  use Ecto.Migration

  def up do

    create table(:test) do
      add :bla, :string
      add :id_again, :integer
      add :blup, :float, default: 0.0
      timestamps()
    end
  end

  def down do
    drop table(:test)
  end
end
