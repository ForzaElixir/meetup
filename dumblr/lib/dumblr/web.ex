defmodule Dumblr.Web do
  use Plug.Router
  require Logger

  plug :match
  plug :dispatch

  get "/" do
    posts = [
      %{title: "Good news", content: "I have good news."},
      %{title: "Bad news", content: "I have some bad news."},
    ]
    content = render("index.html.eex", blog_title: "Dumblr Blog", posts: posts)
    send_resp(conn, 200, content)
  end


  defp render(path, bindings)  do
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

