defmodule SyukatsuSchedulerWeb.SheetLive.Show do
  use SyukatsuSchedulerWeb, :live_view

  alias SyukatsuScheduler.EntrySheet

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:sheet, EntrySheet.get_sheet!(id))}
  end

  defp page_title(:show), do: "Show Sheet"
  defp page_title(:edit), do: "Edit Sheet"
end