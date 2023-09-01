defmodule SyukatsuSchedulerWeb.CompanyLive.FormComponent do
  use SyukatsuSchedulerWeb, :live_component

  alias SyukatsuScheduler.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>更新後の応募情報を記述してください</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="company-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="企業名" />
        <.input field={@form[:status]} type="text" label="現在の状態" />
        <.input field={@form[:schedule]} type="date" label="予定" />
        <.input field={@form[:url]} type="text" label="応募URL" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Company</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{company: company} = assigns, socket) do
    changeset = Accounts.change_company(company)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"company" => company_params}, socket) do
    changeset =
      socket.assigns.company
      |> Accounts.change_company(company_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"company" => company_params}, socket) do
    case socket.assigns do
      %{user_id: user_id} ->
        save_company(socket, socket.assigns.action, company_params |> Map.put("user_id", user_id))
      _ ->
        save_company(socket, socket.assigns.action, company_params)
    end
  end

  defp save_company(socket, :edit, company_params) do
    case Accounts.update_company(socket.assigns.company, company_params) do
      {:ok, company} ->
        notify_parent({:saved, company})

        {:noreply,
         socket
         |> put_flash(:info, "Company updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_company(socket, :new, company_params) do
    case Accounts.create_company(company_params) do
      {:ok, company} ->
        notify_parent({:saved, company})

        {:noreply,
         socket
         |> put_flash(:info, "Company created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
