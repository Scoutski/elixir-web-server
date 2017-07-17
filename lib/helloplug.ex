defmodule Router do
  defmacro __using__(_opts) do
    quote do
      def init(options) do
        options
      end
      def call(conn, _opts) do
        route(conn.method, conn.path_info, conn)
      end
    end
  end
end

defmodule UserRouter do
  use Router
  # This matches GET /hello/:user_id
  require EEx
  EEx.function_from_file :defp, :template_show_user, "templates/show_user.eex", [:user]
  def route("GET", ["users", user_id], conn) do
    case Helloplug.Repo.get(User, user_id) do
      nil ->
        conn
          |> Plug.Conn.send_resp(404, "User with that ID not found")
      user ->
        page_contents = template_show_user(user)
        conn
          |> Plug.Conn.put_resp_content_type("text/html")
          |> Plug.Conn.send_resp(200, page_contents)
    end
  end

  def route("POST", ["users"], conn) do
    # Accept the incoming data somehow
    conn |> Plug.Conn.send_resp(200, "hello, world!")
  end

  def route(_method, _path, conn) do
    conn |> Plug.Conn.send_resp(404, "There isn't a users route that matches that :/")
  end
end

defmodule WebsiteRouter do
  use Router

  # Route any incoming requests that start
  # with /users to the UserRouter module.
  @user_route_options UserRouter.init([])
  def route("GET", ["users" | path], conn) do
    UserRouter.call(conn, @user_router_options)
  end

  def route(_method, _path, conn) do
    conn |> Plug.Conn.send_resp(404, "I have no idea where you are trying to go...")
  end
end

defmodule Helloplug.Repo do
  use Ecto.Repo,
  otp_app: :helloplug,
  adapter: Sqlite.Ecto
end

defmodule User do
  use Ecto.Model

  schema "users" do
    # id is implicit
    field :first_name, :string
    field :last_name, :string
  end
end
