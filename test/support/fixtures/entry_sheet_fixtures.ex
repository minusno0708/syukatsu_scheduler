defmodule SyukatsuScheduler.EntrySheetFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SyukatsuScheduler.EntrySheet` context.
  """

  @doc """
  Generate a sheet.
  """
  def sheet_fixture(attrs \\ %{}) do
    {:ok, sheet} =
      attrs
      |> Enum.into(%{
        item: "some item",
        content: "some content"
      })
      |> SyukatsuScheduler.EntrySheet.create_sheet()

    sheet
  end
end
