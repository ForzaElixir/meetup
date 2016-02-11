defmodule Dumblr.Web do
  use Plug.Router
  require Logger

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "hello")
  end

  def start do
    Logger.info("Dumblr starting on port 8000")
    Plug.Adapters.Cowboy.http __MODULE__, [], port: 8000
  end

  # To stop:
  # Plug.Adapters.Cowboy.shutdown Dumblr.Web.HTTP

end

