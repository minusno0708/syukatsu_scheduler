defmodule SyukatsuSchedulerWeb.SheetLive.Show do
  use SyukatsuSchedulerWeb, :live_view

  alias SyukatsuScheduler.Accounts
  alias SyukatsuScheduler.EntrySheet
  alias SyukatsuSchedulerWeb.RenderErrors

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    {:ok, user_id} = Accounts.get_userid_from_usertoken(user_token)

    {:ok, socket |> assign(:current_user_id, user_id)}
  end

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:current_user_id, nil)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    sheet = EntrySheet.get_sheet!(id)
    sheet_author = Accounts.get_company!(sheet.company_id).user_id

    if socket.assigns.current_user_id == sheet_author do
      {:noreply,
        socket
        |> assign(:page_title, page_title(socket.assigns.live_action))
        |> assign(:sheet, EntrySheet.get_sheet!(id))}

    else
      {:noreply,
        socket
        |> assign(:error, RenderErrors.render_error(:forbidden))}
    end

  end

  defp page_title(:show), do: "Show Sheet"
  defp page_title(:edit), do: "Edit Sheet"

  defp text_indention(nil), do: nil
  defp text_indention(text), do: String.replace(text,  "\n", "<br/>")
end
