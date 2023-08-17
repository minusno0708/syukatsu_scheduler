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
        <:subtitle>Use this form to manage sheet records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="sheet-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:item]} type="text" label="Item" />
        <div>
          <label for="content-input">Content</label>
          <textarea id="content-textarea" name="sheet[content]" phx-hook="EnableEnter" rows="5" cols="50"><%= input_value(@form, :content) %></textarea>
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
    IO.puts("^^^^update^^^^")
    IO.inspect(assigns)
    changeset = EntrySheet.change_sheet(sheet)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"sheet" => sheet_params}, socket) do
    IO.puts("^^^^handle_event_validate^^^^")
    IO.inspect(sheet_params)
    changeset =
      socket.assigns.sheet
      |> EntrySheet.change_sheet(sheet_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"sheet" => sheet_params}, socket) do
    IO.puts("^^^^handle_event_save^^^^")
    IO.inspect(sheet_params)
    save_sheet(socket, socket.assigns.action, sheet_params)
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
    IO.puts("^^^^save_sheet^^^^")
    IO.inspect(sheet_params)
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
    IO.puts("^^^^assign_form^^^^")
    IO.inspect(changeset)
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
