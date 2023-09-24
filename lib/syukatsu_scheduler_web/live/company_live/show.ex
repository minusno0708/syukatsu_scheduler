defmodule SyukatsuSchedulerWeb.CompanyLive.Show do
  use SyukatsuSchedulerWeb, :live_view

  alias SyukatsuScheduler.Accounts
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
    company = Accounts.get_company!(id)

    if socket.assigns.current_user_id == company.user_id do
      {:noreply,
        socket
        |> assign(:page_title, page_title(socket.assigns.live_action))
        |> assign(:company, company)}

    else
      {:noreply,
        socket
        |> assign(:error, RenderErrors.render_error(:forbidden))}
    end
  end

  defp page_title(:show), do: "Show Company"
  defp page_title(:edit), do: "Edit Company"
end
