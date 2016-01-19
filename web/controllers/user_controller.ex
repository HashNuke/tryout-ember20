defmodule Blog.UserController do
  use Blog.Web, :controller
  alias Blog.ScanQuery
  alias Blog.Repo

  def index(conn, params) do
    users = Repo.all(Blog.User)
    json_api conn, users
  end


  def show(conn, params) do
    user = Repo.get(Blog.User, params["id"])
    json_api conn, user
  end


  defp json_api(conn, items) when is_list(items) do
    formatted = %{
      links: %{
        self: "/users"
      },
      data: Enum.map(items, &format_item/1)
    }

    json conn, formatted
  end


  defp json_api(conn, item) do
    formatted = %{
      links: %{
        self: "/users/#{item.id}"
      },
      data: format_item(item)
    }

    json conn, formatted
  end


  defp format_item(user) do
    %{
      type: "user",
      id: user.id,
      attributes: %{
        name: user.name
      },
      relationships: %{
        posts: %{
          links: %{
            self: "/users/#{user.id}/posts"
          }
        }
      }
    }
  end

end
