defmodule Blog.PostController do
  use Blog.Web, :controller
  alias Blog.ScanQuery
  alias Blog.Repo
  import Ecto.Query


  def index(conn, params) do
    posts = Blog.Post
    |> where([user_id: ^params["user_id"]])
    |> Repo.all
    json_api conn, posts, [user_id: params["user_id"]]
  end


  defp json_api(conn, items, opts \\ []) when is_list(items) do
    formatted = %{
      links: %{
        self: "/users/#{opts[:user_id]}/posts"
      },
      data: Enum.map(items, &(format_item &1, opts))
    }

    json conn, formatted
  end


  defp format_item(item, opts \\ []) do
    %{
      type: "post",
      id: item.id,
      attributes: %{
        title: item.title,
        body: item.body
      },
      relationships: %{
        posts: %{
          links: %{
            self: "/posts/#{item.id}"
          }
        },
        user: %{
          links: %{
            self: "/users/#{opts[:user_id]}"
          }
        }
      }
    }
  end
end
