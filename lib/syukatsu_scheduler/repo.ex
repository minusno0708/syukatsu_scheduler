defmodule SyukatsuScheduler.Repo do
  use Ecto.Repo,
    otp_app: :syukatsu_scheduler,
    adapter: Ecto.Adapters.Postgres
end
