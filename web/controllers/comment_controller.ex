defmodule Blog.CommentController do
  use Blog.Web, :controller
  alias Blog.ScanQuery
  alias Blog.Repo
  import Ecto.Query

  def index(conn, params) do
    posts = Blog.Comment
    |> where([post_id: ^params["post_id"]])
    |> Repo.all

    json_api conn, posts, [post_id: params["post_id"]]
  end


  defp json_api(conn, items) do
    json_api conn, items, []
  end


  defp json_api(conn, items, opts) when is_list(items) do
    formatted = %{
      links: %{
        self: "/posts/#{opts[:post_id]}/comments"
      },
      data: Enum.map(items, &(format_item &1, opts))
    }

    json conn, formatted
  end


  defp format_item(item, opts) do
    %{
      type: "comment",
      id: item.id,
      attributes: %{
        body: item.body
      },
      relationships: %{
        post: %{
          links: %{
            self: "/posts/#{item.id}"
          }
        }
      }
    }
  end
end
