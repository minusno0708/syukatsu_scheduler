defmodule SyukatsuSchedulerWeb.CompanyLive.Index do
  use SyukatsuSchedulerWeb, :live_view

  alias SyukatsuScheduler.Accounts
  alias SyukatsuScheduler.Accounts.Company

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    case Accounts.get_companies_by_user_token(user_token) do
      {:ok, companies} ->
        {:ok, stream(socket, :companies, companies)}
      {:error, _reason} ->
        {:ok, assign(socket, :error, "Unable to retrieve companies")}
    end
  end

  def mount(_params, _session, socket) do
    {:ok, stream(socket, :companies, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Company")
    |> assign(:company, Accounts.get_company!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Company")
    |> assign(:company, %Company{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Companies")
    |> assign(:company, nil)
  end

  @impl true
  def handle_info({SyukatsuSchedulerWeb.CompanyLive.FormComponent, {:saved, company}}, socket) do
    {:noreply, stream_insert(socket, :companies, company)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    company = Accounts.get_company!(id)
    {:ok, _} = Accounts.delete_company(company)

    {:noreply, stream_delete(socket, :companies, company)}
  end
end
