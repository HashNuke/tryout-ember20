# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Blog.Repo.insert!(%Blog.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


alias Blog.User
alias Blog.Post
alias Blog.Comment
alias Blog.Repo

num_range = 1..5
users = Enum.map(num_range, fn(i)->
  {:ok, user} = User.changeset(%User{}, %{name: "User##{i}"})
  |> Repo.insert
  user
end)


num_range = 1..3
posts = Enum.map users, fn(user)->
  Enum.map num_range, fn(i)->
    {:ok, post} = Post.changeset(%Post{}, %{title: "Post##{i} by #{user.name}", body: "Post content##{i}", user_id: user.id})
    |> Repo.insert
    post
  end
end


num_range = 1..4
Repo.all(Post)
|> Enum.map(fn(post)->
  Enum.map(num_range, fn(i)->
    Comment.changeset(%Comment{}, %{body: "Comment##{i} for #{post.title}"})
    |> Repo.insert
  end)
end)
