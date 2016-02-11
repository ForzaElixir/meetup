defmodule Dumblr.Web do
  use Plug.Router
  require Logger

  plug :match
  plug Plug.Parsers, parsers: [:urlencoded]
  plug :dispatch

  get "/" do
    # TODO: replace posts with actual content from database.
    posts = [
      %{title: "Good news", content: "I have good news."},
      %{title: "Bad news", content: "I have some bad news."},
    ]
    content = render("index.html.eex", posts: posts)
    send_resp(conn, 200, content)
  end

  get "/posts/new" do
    content = render("new.html.eex")
    send_resp(conn, 200, content)
  end

  get "/posts/:id" do
    # TODO: get from database
    post = %{title: "Brand new bag", content: "Papa's got a brand new bag"}
    content = render("post.html.eex", post: post)
    send_resp(conn, 200, content)
  end

  post "/posts" do
    # TODO: Save post using Ecto
    conn
    |> put_resp_header("Location", "/posts/1")
    |> send_resp(302, "")
  end

  match _ do
    send_resp(conn, 404, "not found")
  end

  defp render(path, bindings \\ [])  do
    full_path = Application.app_dir(:dumblr, "priv/web/" <> path)
    content = EEx.eval_file(full_path, bindings)
  end


  def start do
    Logger.info("Dumblr starting on port 8000")
    Plug.Adapters.Cowboy.http __MODULE__, [], port: 8000
  end

  # To stop:
  # Plug.Adapters.Cowboy.shutdown Dumblr.Web.HTTP

end

