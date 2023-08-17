defmodule SyukatsuSchedulerWeb.SheetLiveTest do
  use SyukatsuSchedulerWeb.ConnCase

  import Phoenix.LiveViewTest
  import SyukatsuScheduler.EntrySheetFixtures

  @create_attrs %{item: "some item", content: "some content"}
  @update_attrs %{item: "some updated item", content: "some updated content"}
  @invalid_attrs %{item: nil, content: nil}

  defp create_sheet(_) do
    sheet = sheet_fixture()
    %{sheet: sheet}
  end

  describe "Index" do
    setup [:create_sheet]

    test "lists all sheets", %{conn: conn, sheet: sheet} do
      {:ok, _index_live, html} = live(conn, ~p"/sheets")

      assert html =~ "Listing Sheets"
      assert html =~ sheet.item
    end

    test "saves new sheet", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/sheets")

      assert index_live |> element("a", "New Sheet") |> render_click() =~
               "New Sheet"

      assert_patch(index_live, ~p"/sheets/new")

      assert index_live
             |> form("#sheet-form", sheet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#sheet-form", sheet: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sheets")

      html = render(index_live)
      assert html =~ "Sheet created successfully"
      assert html =~ "some item"
    end

    test "updates sheet in listing", %{conn: conn, sheet: sheet} do
      {:ok, index_live, _html} = live(conn, ~p"/sheets")

      assert index_live |> element("#sheets-#{sheet.id} a", "Edit") |> render_click() =~
               "Edit Sheet"

      assert_patch(index_live, ~p"/sheets/#{sheet}/edit")

      assert index_live
             |> form("#sheet-form", sheet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#sheet-form", sheet: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sheets")

      html = render(index_live)
      assert html =~ "Sheet updated successfully"
      assert html =~ "some updated item"
    end

    test "deletes sheet in listing", %{conn: conn, sheet: sheet} do
      {:ok, index_live, _html} = live(conn, ~p"/sheets")

      assert index_live |> element("#sheets-#{sheet.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#sheets-#{sheet.id}")
    end
  end

  describe "Show" do
    setup [:create_sheet]

    test "displays sheet", %{conn: conn, sheet: sheet} do
      {:ok, _show_live, html} = live(conn, ~p"/sheets/#{sheet}")

      assert html =~ "Show Sheet"
      assert html =~ sheet.item
    end

    test "updates sheet within modal", %{conn: conn, sheet: sheet} do
      {:ok, show_live, _html} = live(conn, ~p"/sheets/#{sheet}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Sheet"

      assert_patch(show_live, ~p"/sheets/#{sheet}/show/edit")

      assert show_live
             |> form("#sheet-form", sheet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#sheet-form", sheet: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/sheets/#{sheet}")

      html = render(show_live)
      assert html =~ "Sheet updated successfully"
      assert html =~ "some updated item"
    end
  end
end
