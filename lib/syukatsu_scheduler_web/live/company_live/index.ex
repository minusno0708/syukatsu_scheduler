defmodule SyukatsuSchedulerWeb.CompanyLive.Index do
  use SyukatsuSchedulerWeb, :live_view

  alias SyukatsuScheduler.Accounts
  alias SyukatsuScheduler.Accounts.Company

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    case Accounts.get_userid_from_usertoken(user_token) do
      {:ok, user_id} ->
        case Accounts.get_companies_by_user_id(user_id) do
          {:ok, companies} ->
            {:ok, stream(socket |> assign(:current_user_id, user_id), :companies, companies)}
          {:error, _reason} ->
            {:ok, assign(socket, :error, "Unable to retrieve companies")}
        end

      {:error, _reason} ->
        {:ok, stream(socket |> assign(:current_user_id, nil), :companies, [])}
    end
  end

  def mount(_params, _session, socket) do
    {:ok, stream(socket |> assign(:current_user_id, nil), :companies, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "応募情報更新")
    |> assign(:company, Accounts.get_company!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "応募情報作成")
    |> assign(:company, %Company{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "応募企業一覧")
    |> assign(:company, nil)
  end

  @impl true
  def handle_info({SyukatsuSchedulerWeb.CompanyLive.FormComponent, {:saved, company}}, socket) do
    {:noreply, stream_insert(socket, :companies, company)}
  end

  @impl true
  @spec handle_event(<<_::48>>, map, Phoenix.LiveView.Socket.t()) :: {:noreply, map}
  def handle_event("delete", %{"id" => id}, socket) do
    company = Accounts.get_company!(id)
    {:ok, _} = Accounts.delete_company(company)

    {:noreply, stream_delete(socket, :companies, company)}
  end
end
