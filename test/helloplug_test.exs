defmodule HelloplugTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @website_router_opts WebsiteRouter.init([])
  test "returns a user" do
    conn = conn(:get, "/users/1")
    conn = WebsiteRouter.call(conn, @website_router_opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert String.match?(conn.resp_body, ~r/Fluffums/)
  end
end
