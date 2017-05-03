defmodule ExTest.Repos.Test.Migrations.AddTestTable do
  use Ecto.Migration

  def up do
      create table(:test) do
        :bla, :string
        :id_again, :integer
        :blup, :float, default: 0.0

        timestamps()
      end
    end

    def down do
      drop table(:test)
    end
end
