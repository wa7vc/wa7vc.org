defmodule Wa7vcWeb.ErrorViewTest do
  use Wa7vcWeb.ConnCase, async: true
  use Plug.Test

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  setup do
    conn =
      build_conn()
      |> Plug.Conn.put_private(:phoenix_endpoint, Wa7vcWeb.Endpoint)

    {:ok, conn: conn}
  end

  #test "renders 404 on bad path" do
    #conn = get(build_conn(), "/badpath")
    #assert conn.resp_body =~ "not found"
  #end

  test "renders 404.html", %{conn: conn} do
    page = render_to_string(Wa7vcWeb.ErrorView, "404.html", conn: conn)
    assert page =~ "The page you were looking for could not be found"

    # And make sure it is rendering with the header menus at least
    # TODO: This should actually be checking that the links and such are there. Perhaps passing off to layout view tests?
    assert page =~ "WA7VC"
    assert page =~ "About"
    assert page =~ "Events"
    assert page =~ "On-Air"
  end

  test "renders 500.html" do
    assert render_to_string(Wa7vcWeb.ErrorView, "500.html", []) ==
           "Internal Server Error"
  end
end
