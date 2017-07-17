# This is not being used, this is just the most basic router
# I was able to make with a plug
defmodule Helloplug do
  def init(options) do
    options
  end
  # conn is kind of like req/res object
  def call(conn, _opts) do
    IO.puts "Request recieved"
    conn |> Plug.Conn.put_resp_header("Server", "Plug") |> Plug.Conn.send_resp(200, "Hello, world!")
    conn2 = Plug.Conn.put_resp_header(conn, "Server", "Plug")
    route(conn2.method, conn2.path_info, conn2)
  end

  # This matches GET /hello
  def route("GET", ["hello"], conn) do
    conn |> Plug.Conn.send_resp(200, "hello, world!")
  end

  # 404 route
  def route(_method, _path, conn) do
    conn |> Plug.Conn.send_resp(404, "404 - Page not found :(")
  end
end