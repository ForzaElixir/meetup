defmodule Dumblr.Web do
  use Plug.Router
  require Logger

  plug :match
  plug :dispatch

  get "/" do
    template = File.read!(Application.app_dir(:dumblr, "priv/web/index.html.eex"))
    content = EEx.eval_string(template, [title: "Dumblr Blog"])
    send_resp(conn, 200, content)
  end

  def start do
    Logger.info("Dumblr starting on port 8000")
    Plug.Adapters.Cowboy.http __MODULE__, [], port: 8000
  end

  # To stop:
  # Plug.Adapters.Cowboy.shutdown Dumblr.Web.HTTP

end

