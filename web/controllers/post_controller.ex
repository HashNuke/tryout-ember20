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


  def show(conn, params) do
    post = Repo.get Blog.Post, params["id"]
    json_api conn, post
  end


  defp json_api(conn, items) do
    json_api conn, items
  end


  defp json_api(conn, items, opts) when is_list(items) do
    formatted = %{
      links: %{
        self: "/users/#{opts[:user_id]}/posts"
      },
      data: Enum.map(items, &(format_item &1, opts))
    }

    json conn, formatted
  end


  defp json_api(conn, item, opts) do
    formatted = %{
      links: %{
        self: "/posts/#{item.id}"
      },
      data: format_item(item)
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
        comments: %{
          links: %{
            self: "/posts/#{item.id}/comments"
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
