defmodule SyukatsuSchedulerWeb.RenderErrors do
  def render_error(:forbidden) do
    "不正なユーザーによるアクセスです"
  end
end
