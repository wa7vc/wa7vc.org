defmodule Wa7vcWeb.PageControllerTest do
  use Wa7vcWeb.ConnCase

  # Sanity check front page rendering
  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "WA7VC, the Valley Camp Amateur Radio Group"
  end
end
