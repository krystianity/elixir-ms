defmodule ExTest.Repos.Test.Migrations.AddTestChange do
  use Ecto.Migration

  def change do

    alter table(:test) do
        add :mach_doch, :integer
    end

    index(:test, [:mach_doch])
  end
end
