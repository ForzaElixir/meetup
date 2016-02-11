defmodule Dumblr do
  use Application

  def start(_, _) do
    Dumblr.Web.start
    Supervisor.start_link([], [strategy: :one_for_one])
  end
end
