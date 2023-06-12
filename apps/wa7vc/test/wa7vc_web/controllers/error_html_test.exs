defmodule Wa7vcWeb.ErrorHTMLTest do
  use Wa7vcWeb.ConnCase, async: true

  # Bring render_to_string/4 for testing custom views
  import Phoenix.Template

  test "renders 404.html" do
    page = render_to_string(Wa7vcWeb.ErrorHTML, "404", "html", [])
    assert page =~ "The page you were looking for was not found"
    assert page =~ "window.location.replace(\"/?flash_error=404\")" # Check that the correct redirect code is present at least
  end

  test "renders 500.html" do
    page = render_to_string(Wa7vcWeb.ErrorHTML, "500", "html", [])
    assert page =~ "Something broke"
    assert page =~ "href=\"/" # Make sure we have a link back to the home page
  end
end
