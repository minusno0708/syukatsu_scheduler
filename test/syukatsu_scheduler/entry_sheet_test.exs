defmodule SyukatsuScheduler.EntrySheetTest do
  use SyukatsuScheduler.DataCase

  alias SyukatsuScheduler.EntrySheet

  describe "sheets" do
    alias SyukatsuScheduler.EntrySheet.Sheet

    import SyukatsuScheduler.EntrySheetFixtures

    @invalid_attrs %{item: nil, content: nil}

    test "list_sheets/0 returns all sheets" do
      sheet = sheet_fixture()
      assert EntrySheet.list_sheets() == [sheet]
    end

    test "get_sheet!/1 returns the sheet with given id" do
      sheet = sheet_fixture()
      assert EntrySheet.get_sheet!(sheet.id) == sheet
    end

    test "create_sheet/1 with valid data creates a sheet" do
      valid_attrs = %{item: "some item", content: "some content"}

      assert {:ok, %Sheet{} = sheet} = EntrySheet.create_sheet(valid_attrs)
      assert sheet.item == "some item"
      assert sheet.content == "some content"
    end

    test "create_sheet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EntrySheet.create_sheet(@invalid_attrs)
    end

    test "update_sheet/2 with valid data updates the sheet" do
      sheet = sheet_fixture()
      update_attrs = %{item: "some updated item", content: "some updated content"}

      assert {:ok, %Sheet{} = sheet} = EntrySheet.update_sheet(sheet, update_attrs)
      assert sheet.item == "some updated item"
      assert sheet.content == "some updated content"
    end

    test "update_sheet/2 with invalid data returns error changeset" do
      sheet = sheet_fixture()
      assert {:error, %Ecto.Changeset{}} = EntrySheet.update_sheet(sheet, @invalid_attrs)
      assert sheet == EntrySheet.get_sheet!(sheet.id)
    end

    test "delete_sheet/1 deletes the sheet" do
      sheet = sheet_fixture()
      assert {:ok, %Sheet{}} = EntrySheet.delete_sheet(sheet)
      assert_raise Ecto.NoResultsError, fn -> EntrySheet.get_sheet!(sheet.id) end
    end

    test "change_sheet/1 returns a sheet changeset" do
      sheet = sheet_fixture()
      assert %Ecto.Changeset{} = EntrySheet.change_sheet(sheet)
    end
  end
end
