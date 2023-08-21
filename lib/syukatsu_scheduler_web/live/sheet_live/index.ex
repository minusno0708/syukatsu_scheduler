defmodule SyukatsuSchedulerWeb.SheetLive.Index do
  use SyukatsuSchedulerWeb, :live_view

  alias SyukatsuScheduler.EntrySheet
  alias SyukatsuScheduler.EntrySheet.Sheet

  @impl true
  def mount(params, _session, socket) do
    company_id = params["company_id"]
    case EntrySheet.get_sheets_by_company(company_id) do
      {:ok, sheets} ->
        {:ok, stream(socket |> assign(:company_id, params["company_id"]), :sheets, sheets)}
      {:error, reason} ->
        {:ok, assign(:error, reason)}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Sheet")
    |> assign(:sheet, EntrySheet.get_sheet!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Sheet")
    |> assign(:sheet, %Sheet{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Sheets")
    |> assign(:sheet, nil)
  end

  @impl true
  def handle_info({SyukatsuSchedulerWeb.SheetLive.FormComponent, {:saved, sheet}}, socket) do
    {:noreply, stream_insert(socket, :sheets, sheet)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    sheet = EntrySheet.get_sheet!(id)
    {:ok, _} = EntrySheet.delete_sheet(sheet)

    {:noreply, stream_delete(socket, :sheets, sheet)}
  end

  defp text_slice(nil, _length), do: nil
  defp text_slice(text, length) do
    case String.length(text) > length do
      true -> String.slice(text, 0, length-3) <> "..."
      _ -> text
    end
  end
end
