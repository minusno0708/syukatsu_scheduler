defmodule SyukatsuSchedulerWeb.SheetLive.Index do
  use SyukatsuSchedulerWeb, :live_view

  alias SyukatsuScheduler.Accounts
  alias SyukatsuScheduler.EntrySheet
  alias SyukatsuScheduler.EntrySheet.Sheet
  alias SyukatsuSchedulerWeb.RenderErrors

  @impl true
  def mount(%{"company_id" => company_id}, %{"user_token" => user_token}, socket) do
    {:ok, current_user_id} = Accounts.get_userid_from_usertoken(user_token)

    if Accounts.get_company!(company_id).user_id == current_user_id do
      case EntrySheet.get_sheets_by_company(company_id) do
        {:ok, sheets} ->
          {:ok, stream(socket
            |> assign(:company_id, company_id),
          :sheets, sheets)}
        {:error, reason} ->
          {:ok, socket |> assign(:error, reason)}
      end

    else
      {:ok, socket |> assign(:error, RenderErrors.render_error(:forbidden))}
    end

  end

  def mount(%{"company_id" => company_id}, _session, socket) do
    case EntrySheet.get_sheets_by_company(company_id) do
      {:ok, sheets} ->
        {:ok, stream(socket |> assign(:company_id, company_id), :sheets, sheets)}
      {:error, reason} ->
        {:ok, socket |> assign(:error, reason)}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "ES項目更新")
    |> assign(:sheet, EntrySheet.get_sheet!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "ES新規項目作成")
    |> assign(:sheet, %Sheet{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "ES項目一覧")
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
