defmodule Wa7vcWeb.DMRPage do
  defstruct [
    :date,
    :about_header,
    :about_content,
    :schedule_content,
    image: nil,
    image_alt: nil,
    meta_desc: "The Pacific Northwest Digital Mobile Radio (WA7DMR) yearly gathering, the best event to find out the latest greatest information about DMR!",
  ]
end


defmodule Wa7vcWeb.DMRGatheringController do
  use Wa7vcWeb, :controller
  alias Wa7vcWeb.DMRPage

  plug :dmr_year

  @all_data %{
    "2019" => %DMRPage{
      date: "May 18-19",
      about_header: "1st Annual Pacific Northwest DMR Gathering",
      about_content: """
        <p>
          This event is sponsored jointly by the <a href="http://www.pnwdigital.net/index.html">PNW DMR Network</a> and <a href="https://valleycamp.org/">Valley Camp</a>/<a href="https://wa7vc.org">WA7VC</a>
        </p>
        <p>
          The <a href="http://www.pnwdigital.net/dmrgathering-2019/index.html">Official Event Page</a> has the full details of the event, so check that out for the latest news and schedule, as well as links for more info and to make reservations.
        </p>
      """,
      schedule_content: """
        <p>Saturday presentations from introductory to advanced.</p>
        <p>Sunday morning events now added, single or multiple sessions with SME's, yet to be finalized.</p>
        <p>There will be plenty of time for networking/socializing over the weekend. Check the <a href="http://www.pnwdigital.net/dmrgathering-2019/brochure.pdf">brochure</a> and the <a href="http://www.pnwdigital.net/dmrgathering-2019/index.html">Official Event Page</a> for the latest information.</p>
      """,
    },
    "2020" => %DMRPage{
      date: "May 15-17",
      about_header: "2nd Annual Pacific Northwest DMR Gathering",
      about_content: """
        <p>
          <b>CANCELLED due to Covid-19 Pandemic</b><br />
          Check back for information and dates for 2021!
        </p>
        <p>
          This event is sponsored jointly by the <a href="http://www.pnwdigital.net/index.html">PNW DMR Network</a> and <a href="https://valleycamp.org/">Valley Camp</a>/<a href="https://wa7vc.org">WA7VC</a><br />
          The <a href="http://www.pnwdigital.net/dmrgathering-2020/index.html">Official Event Page</a> has the full details of the event, so check that out for the latest news and schedule, as well as links for more info and to make reservations.
        </p>
      """,
      schedule_content: """
        <ul>
          <li>Wash your Hands</li>
          <li>Socially isolate yourself in your 'shack</li>
          <li>Fire up your radio and say hello to all the other isolated hams on DMR!</li>
        </ul>
      """,
      meta_desc: "2020 event cancelled due to Covid-19",
    },
    "2021" => %DMRPage{
      date: "May 18-19",
      about_header: "3rd-ish Annual Pacific Northwest DMR Gathering",
      about_content: """
        <p>
          <b>CANCELLED due to Covid-19 Pandemic</b><br />
          Check back for information and dates for 2022 as the situation develops, but it's looking good for May 2022, so pencil in those calendars!
        </p>
        <p>
          This event is sponsored jointly by the <a href="http://www.pnwdigital.net/index.html">PNW DMR Network</a> and <a href="https://valleycamp.org/">Valley Camp</a>/<a href="https://wa7vc.org">WA7VC</a><br />
          The <a href="http://www.pnwdigital.net/dmrgathering-2021/index.html">Official Event Page</a> has the full details of the event, so check that out for the latest news and schedule, as well as links for more info and to make reservations.
        </p>
      """,
      schedule_content: """
        <p>Saturday presentations from introductory to advanced.</p>
        <p>Sunday morning events now added, single or multiple sessions with SME's, yet to be finalized.</p>
        <p>There will be plenty of time for networking/socializing over the weekend. Check the <a href="http://www.pnwdigital.net/dmrgathering-2019/brochure.pdf">brochure</a> and the <a href="http://www.pnwdigital.net/dmrgathering-2019/index.html">Official Event Page</a> for the latest information.</p>
      """,
      meta_desc: "2021 event cancelled due to Covid-19",
      },
    "2023" => %DMRPage{
      date: "July 28-30",
      about_header: "4th Annual Pacific Northwest DMR Gathering",
      about_content: """
        <p>
          This time we won't be stopped!<br />
          This event is sponsored jointly by the <a href="http://www.pnwdigital.net/index.html">PNW DMR Network</a> and <a href="https://valleycamp.org/">Valley Camp</a>/<a href="https://wa7vc.org">WA7VC</a>
        </p>
        <p>
          The <a href="https://pnwdigital.net/pnwdigital-gathering-07-2023/">Blog Post announcing the event <i class="fas fa-external-link-alt"></i></a> has the full details, so check that out for the latest news and schedule, as well as links for more info and to make reservations.
        </p>
      """,
      schedule_content: """
        <p>To be announced!</p>
      """,
    },
  }

  defp dmr_year(conn, _opts) do
    valid_years = @all_data |> Map.keys() |> Enum.sort()
    latest_year = List.last(valid_years)
    requested_year = conn.path_params["year"]

    conn = cond do
      requested_year == nil ->
        conn
        |> assign(:load_year, latest_year)
        |> assign(:prev_year, Enum.at(valid_years, Enum.count(valid_years)-2))
        |> assign(:next_year, nil)
      requested_year in valid_years ->
        requested_year_index = valid_years |> Enum.find_index(fn y -> y == requested_year end)
        last_year_index = Enum.count(valid_years)-1
        prev_year = case requested_year_index > 0 do
          true -> valid_years |> Enum.at(requested_year_index - 1)
          false -> nil
        end
        next_year = case requested_year_index < last_year_index do
          true ->  valid_years |> Enum.at(requested_year_index + 1)
          false -> nil
        end
        conn
        |> assign(:load_year, requested_year)
        |> assign(:prev_year, prev_year)
        |> assign(:next_year, next_year)
      true ->
        conn 
        |> put_flash(:error, "No DMR Gathering page for #{requested_year}, showing the next event year (#{latest_year}) instead.")
        |> assign(:load_year, latest_year)
        |> assign(:prev_year, Enum.at(valid_years, Enum.count(valid_years)-2))
        |> assign(:next_year, nil)
    end

    d = @all_data[conn.assigns.load_year]

    {img, alt} = case d.image do
      nil -> {"/images/overhead-640x480.png", "Looking down on an event"}
      i ->
        case d.image_alt do
          nil -> {i, "Image of the event"}
          t -> {i, t}
        end
    end

    conn
    |> assign(:date, d.date)
    |> assign(:about_header, d.about_header)
    |> assign(:about_content, d.about_content)
    |> assign(:schedule_content, d.schedule_content)
    |> assign(:image, img)
    |> assign(:image_alt, alt)
    |> assign(:meta_attrs, [ %{name: "description", content: d.meta_desc} ])
  end

  def index(conn, _params) do
    render(conn, "dmr_year.html")
  end

end
