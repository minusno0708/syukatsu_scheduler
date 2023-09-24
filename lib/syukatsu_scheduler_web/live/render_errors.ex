defmodule SyukatsuSchedulerWeb.RenderErrors do
  def render_error(error) do
    case error do
      :forbidden ->
        "不正なユーザーによるアクセスです"
      _ ->
        "エラーが発生しました"
    end
  end
end
