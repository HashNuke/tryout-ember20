defmodule Blog.UserController do
  use Blog.Web, :controller
  alias Blog.ScanQuery
  alias Blog.Repo

  def index(conn, params) do
    users = Repo.all(Blog.User)
    |> Enum.map(&format_user/1)

    json conn, %{data: users}
  end


  defp format_user(user) do
    %{
      type: "user",
      id: user.id,
      attributes: %{
        name: user.name
      }
    }
  end
end
