defmodule SyukatsuSchedulerWeb.SheetLive.FormComponent do
  import Phoenix.HTML.Form

  use SyukatsuSchedulerWeb, :live_component

  alias SyukatsuScheduler.EntrySheet

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>ESの項目と内容を記述する</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="sheet-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:item]} type="text" label="項目" />
        <div>
          <label for="sheet_content" class="block text-sm font-semibold leading-6 text-zinc-800" style="display: block;">内容</label>
          <textarea id="content-textarea" name="sheet[content]" phx-hook="EnableEnter"  rows="8" class="mt-2 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6 phx-no-feedback:border-zinc-300 phx-no-feedback:focus:border-zinc-400 border-zinc-300 focus:border-zinc-400"><%= input_value(@form, :content) %></textarea>
        </div>

        <:actions>
          <.button phx-disable-with="Saving...">Save Sheet</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{sheet: sheet} = assigns, socket) do
    changeset = EntrySheet.change_sheet(sheet)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"sheet" => sheet_params}, socket) do
    changeset =
      socket.assigns.sheet
      |> EntrySheet.change_sheet(sheet_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"sheet" => sheet_params}, socket) do
    company_id = socket.assigns.company_id
    save_sheet(socket, socket.assigns.action, sheet_params |> Map.put("company_id", company_id))
  end

  defp save_sheet(socket, :edit, sheet_params) do
    case EntrySheet.update_sheet(socket.assigns.sheet, sheet_params) do
      {:ok, sheet} ->
        notify_parent({:saved, sheet})

        {:noreply,
         socket
         |> put_flash(:info, "Sheet updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_sheet(socket, :new, sheet_params) do
    case EntrySheet.create_sheet(sheet_params) do
      {:ok, sheet} ->
        notify_parent({:saved, sheet})

        {:noreply,
         socket
         |> put_flash(:info, "Sheet created successfully")
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
