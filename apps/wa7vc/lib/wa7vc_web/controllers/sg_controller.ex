defmodule Wa7vcWeb.SGPage do
  defstruct [
    :date,
    :about_header,
    :about_content,
    :schedule_content,
    location: nil,
    location_content: nil,
    retrospective_content: nil,
    image: nil,
    image_alt: nil,
    meta_desc: "Our signature event, the Summer Gathering brings hams together for presentations, troubleshooting sessions, food, friends, and antennas!",
    cancelled: false,
  ]
end


defmodule Wa7vcWeb.SGController do
  use Wa7vcWeb, :controller
  alias Wa7vcWeb.SGPage

  plug :sg_year

  @all_data %{
    "2018" => %SGPage {
      date: "September 7-9",
      about_header: "21 Years Running!",
      about_content: """
        <p>We've been doing this for a while now! Once again, this year's Summer Gathering will be filled with lectures, show-and-tell, food, and antennas. In addition to the schedule of events shown below, attendees are often showing off their own projects, selling or trading used items, and helping each other construct or repair all manner of things!</p>
        <p>As usual, the event will be held at <a href="https://valleycamp.org">Valley Camp</a>. For reservations please contact <a href="mailto:info@valleycamp.org">info@valleycamp.org</a>.</p>
        <p>For questions, please contact <a href="mailto:summergathering@wa7vc.org">summergathering@wa7vc.org</a>.</p>
        <p>To stay up to date on the latest news, <a href="https://tinyletter.com/nwaprssg">sign up for the newsletter <i class="fas fa-external-link-alt"></i></a>. (We promise, we don't send too many emails!)</p>
        <p>If you plan on attending the Summer Gathering please fill out <a href="https://docs.google.com/forms/d/e/1FAIpQLSe5XXHETYNkOmMXdwi_SrsMQmOLkLSKVoOZI9Gli5tNNFHiNg/viewform?usp=sf_link">this survey. <i class="fas fa-external-link-alt"></i></a></p>

        <h5>Friends, food, and RF. </h5>
        <p>Breakfast on Saturday and Sunday will be provided by Curt. Lunch on Saturday & Sunday, and dinner on Saturday will provided by the WA7VC club! Coffee will be available throughout. Donations gratefully accepted to help cover the cost of meals, and the chefs would welcome any offered assistance. Lynn, N7CFO, also tells us that some delicious handmade treats may be available Friday and Saturday night, we can't wait!</p>
        <p>Got Ham Radio related equipment to sell, trade or offer for free? Bring it along and make it available from your tailgate, trunk, side door, backpack, or pocket during the event. (Best times will be meal breaks and evenings)</p>
        <p>Several door prizes will be raffeled off Saturday evening. Our thanks to <a href="http://arrl.org">the ARRL <i class="fas fa-external-link-alt"></i></a>, <a href="http://adapterguy.com">The RF Adapter Guy <i class="fas fa-external-link-alt"></i></a>, and<a href="http://www.n3fjp.com">N3FJP Ham Software <i class="fas fa-external-link-alt"></i></a>.</p>
        <p>
          Event Talk-In Frequencies will be the WA7VC local frequencies:
          <ul>
            <li>70cm Simplex: 446.525 (no tone). IRLP Node 7808, Echolink Node 98045</li>
            <li>DSTAR: WA7VC B on 440.01250Mhz + 5.000Mhz</li>
            <li>DMR: We will be monitoring Washington 2. A demonstration Motorola DMR repeater will be onsite. (<a href="http://trbo.org/pnw/demonstration.html">Demonstration Project Information <i class="fas fa-external-link-alt"></i></a>)</li>
          </ul>
        </p>
      """,
      schedule_content: """
        <div class="grid grid-cols-3">
          <div class="">
            <h5>Friday (9/7):</h5>
            <ul class="schedule-list">
              <li>Setup</li>
              <li>Demonstrations</li>
              <li>Fix-It Bench</li>
              <li>Social Time</li>
              <li><time>1830 - 2200:</time> Discussion time around the campfire</li>
            </ul>
          </div>

          <div class="">
            <h5>Saturday (9/8):</h5>
            <ul class="schedule-list">
              <li><time>0700 - 0830:</time> Breakfast - Curt WR5J</li>
              <li><time>0845 - 0900:</time> Introduction - Thom K7FZO</li>
              <li><time>0900 - 1000:</time> Marine Marathon Digital Support - Corky AF4PM</li>
              <li><time>1000 - 1100:</time> 44net and VPN - John K7VE</li>
              <li><time>1100 - 1200:</time> FSQ (How it is used it Watcom County EOC) - Budd WB7FHC</li>
              <li><time>1200 - 1300:</time> Lunch provided by WA7VC, donations will be accepted to cover the cost.</li>
              <li><time>1300 - 1400:</time> DMR, What it is, where did it come from, why you should care - Bob AF9W</li>
              <li><time>1400 - 1500:</time> DMR here in the PNW, how to get involved, what it takes to get started, and why you want to join the group - Brad N7ER</li>
              <li><time>1500 - 1600:</time> HamWAN Overview - Kenny KU7M</li>
              <li><time>1600 - 1700:</time> DRAWS - Digital Radio Amateur Workstation - Bryan K7UDR</li>
              <li><time>1700 - 1730:</time> Door prizes and Wrap-Up - Thom K7FZO</li>
              <li><time>1730 - 1900:</time> Dinner provided by WA7VC, donations accepted to help cover the cost. BBQ Will be hot if you bring your own!</li>
              <li><time>1830 - 2200:</time> Open time for Discussions, Fix-It Bench, Demonstrations, and evening campfire</li>
            </ul>
          </div>

          <div class="">
            <h5>Sunday (9/9):</h5>
            <ul class="schedule-list">
              <li><time>0730 - 0900:</time> Breakfast for all</li>
              <li><time>0900 - 1000:</time> Nature Friendly Amateur Radio - Bruce Prior N7RR</li>
              <li><time>1000 - 1100:</time> RAMROD: Ham Support / RDop - Curt WR5J</li>
              <li><time>1100 - 1200:</time> HamWAN: Tactical Uses - Randy W3RWN</li>
              <li><time>1200 - 1300:</time> Lunch provided by WA7VC, donations will be accepted to cover the cost.</li>
              <li><time>1300 - 1400:</time> Radio has come full circle: From direct conversion, regenerative, tuned radio frequency (TRF), superheterodyne to once again direct conversion using the high horsepower of micro controllers and super fast analog-to-digital converters in Software Defined Radios (SDR)<br />It's just taken almost 100 years. - Mark W7EAZ</li>
            </ul>
          </div>
        </div>
      """,
      retrospective_content: """
        <p>
          Officially we had 89 sign in, but with the drop-ins we know of we believe the official attendance count is 98.<br />
          Which means that each attendee consumed, on average, just under 1 litre of coffee each. Whew!
        </p>
        <p>
          More post-event information can be found in <a href="https://tinyletter.com/nwaprssg/letters/nw-aprs-summer-gathering-2018-follow-up">the newsletter archive<i class="fas fa-external-link-alt"></i></a>.
        </p>
      """
    },
    "2019" => %SGPage{
      date: "September 6-8",
      about_header: "22nd Annual Summer Gathering",
      about_content: """
        <p>Year 22, once more like we did before! As usual, this year's Summer Gathering will be filled with lectures, show-and-tell, food, and antennas. In addition to the schedule of events shown below, attendees are often showing off their own projects, selling or trading used items, and helping each other construct or repair all manner of things!</p>
        <p>As always, the event will be held at <a href="https://valleycamp.org">Valley Camp</a>. For reservations please contact <a href="mailto:info@valleycamp.org">info@valleycamp.org</a>.</p>
        <p>For questions, please contact <a href="mailto:summergathering@wa7vc.org">summergathering@wa7vc.org</a>.</p>
        <p>To stay up to date on the latest news, <a href="https://tinyletter.com/nwaprssg">sign up for the newsletter <i class="fas fa-external-link-alt"></i></a>. (We promise, we don't send too many emails!)</p>
        <p>If you are planning to attend the event please fill out <a href="https://docs.google.com/forms/d/e/1FAIpQLSdGf7MDaeIsDe4nKCKhEcbHStU2M8p78KK7D_qZ-dG5su9Bpg/viewform?usp=sf_link">this RSVP form <i class="fas fa-external-link-alt"></i></a> so we make sure nobody goes hungry!</p>
        <p>
          Event Talk-In Frequency:
          <ul>
            <li>2m Simplex: 146.52 (no tone)</li>
          </ul>
          Other WA7VC local frequencies:
          <ul>
            <li>Echolink: Node 98045 (or Valley Camp)</li>
            <li>IRLP: 7808</li>
            <li>DSTAR: WA7VC B on 440.01250Mhz + 5.000Mhz</li>
            <li>DMR: NorthBend-ValleyCamp 440.7250 + 5.000Mhz (Talkgroup: Local 2)</li>
            <li>APRS: WA7VC-10 Digi-iGate 144.390</li>
          </ul>
        </p>
      """,
      schedule_content: """
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 lg:gap-8">
          <div class="">
            <h5>Friday (9/6):</h5>
            <ul class="schedule-list">
              <li><time>1900:</time> Dessert</li>
            </ul>
          </div>

          <div class="">
            <h5>Saturday (9/7):</h5>
            <ul class="schedule-list">
              <li><time>0700 - 0830:</time> Breakfast at pavilion</li>
              <li><time>0845 - 0900:</time> Opening and introductions - Thom, K7FZO</li>
              <li><time>0900 - 0945:</time> DStar - Scott, N7SS</li> 
              <li><time>1000 - 1045:</time> Digital Mobile Radio, (DMR) - Brad Estill, N7ER</li>
              <li><time>1100 - 1145:</time> APRS - Tom Needham, WA7TBP</li>
              <li><time>1145 - 1300:</time> Lunch (Burgers & brats)</li>
              <li><time>1250:</time> <i>22nd Anual Group Photo</i></li>
              <li><time>1300 - 1345:</time> Balloon Launch. - L. Paul Verhage, KD4STH</li>
              <li><time>1400 - 1445:</time> HAMWAN update. - Kenny Richards,  KU7M</li>
              <li><time>1500 - 1545:</time> 9600 baud packet & DRAWS. - Bryan Hoyer, K7UDR</li>   
              <li><time>1600 - 1800:</time> Elmer stations, tailgate swapmeet & social time<br />
                <ul>
                  <li>DStar - Scott Honaker, N7SS</li>
                  <li>APRS - Tom Needham, WA7TBP</li>
                  <li>DMR - Brad Estill, N7ER</li>
                  <li>WINLINK - Bob Stephens, AF9W</li>
                  <li>3D Printing -  Phil Moscinski, N2EU</li>
                  <li>FL-DIGI - Bob Tykulsker,  KM6SO</li>
                </ul>
              </li>
              <li><time>1800:</time> Spaghetti feed at pavilion.  Social time the rest of the evening</li>
              <li><time>1900:</time> APRS Bunny Hunt. - Tom Needham, WA7TBP</li>
            </ul>
          </div>

          <div class="">
            <h5>Sunday (9/8):</h5>
            <ul class="schedule-list">
              <li><time>0730 - 0830:</time> Pancake breakfast at pavilion</li>
              <li><time>0900 - 0945:</time> 3D Printing, Phil Moscinski, N2EU</li>
              <li><time>1000 - 1045:</time> FL-DIGI.  Bob Tykulsker,  KM6SO</li>
              <li><time>1100 - 1150:</time> PAT Winlink.  Bob Stephens, AF9W</li>
              <li><time>1150 - 1300:</time> Lunch provided</li>
              <li><time>1300 - 1500:</time> Elmer Stations and social time (Same Elmer stations as Saturday)</li>
            </ul>
          </div>
        </div>
      """,
    },
    "2020" => %SGPage{
      meta_desc: "2020 Summer Gathering is cancelled due to Covid-19.",
      cancelled: true,
      date: "September 11-13",
      about_header: "23rd Annual Summer Gathering",
      about_content: """
        <p>
          <b>CANCELLED due to Covid-19 Pandemic</b><br />
          Check back for information and dates for 2021!
        </p>
        <p>To stay up to date on the latest news, <a href="https://tinyletter.com/nwaprssg">sign up for the newsletter <i class="fas fa-external-link-alt"></i></a>. (We promise, we don't send too many emails!)</p>
      """,
      schedule_content: """
        <ul class="schedule-list">
          <li><time>First:</time>Apply hand sanitizer generously (Event repeats as often as needed)</li>
          <li><time>Second:</time>Clean up your 'shack, you're gonna be spending some time in there</li>
          <li><time>Thirdly:</time>Check all your feedlines. You know you haven't done that in a while.</li>
          <li><time>Always:</time>Get on the air with all the other isolated hams!</li>
        </ul>
      """,
      location_content: """
        <p>The ethereal timeless void in which we all now live.</p>
        <div>
          <h5>Directions</h5>
          <p>First star to the right and straight on to morning.</p>
        </div>
      """,
    },
    "2021" => %SGPage{
      meta_desc: "2021 Summer Gathering is cancelled due to covid 19",
      cancelled: true,
      date: "September 11-12",
      about_header: "24th Annual Summer Gathering",
      about_content: """
        <p>
          <b>CANCELLED due to Covid-19</b><br />
          Check back for information and dates for 2022.<br />
        </p>
        <p>To stay up to date on the latest news, <a href="https://tinyletter.com/nwaprssg">sign up for the newsletter <i class="fas fa-external-link-alt"></i></a>. (We promise, we don't send too many emails!)</p>
      """,
      schedule_content: """
        <p>
          If you're interested in presenting a topic next year (2022) please let us know! It's never too early to start putting the schedule together!
        </p>
      """,
    },
    "2022" => %SGPage{
      date: "June 4th",
      location: "Sea-Pac, Seaside OR",
      about_header: "25th Annual Summer Gathering",
      about_content: """
        <p><b>We're takin' this show on the road!</b></p>
        <p>The 25th NWAPRS Summer Gathering will be held at Seaside Oregon at Sea-Pac, June 4th 2022</p>
        <p>Join with Dave, W7GPS on Saturday in the Seaside Convention Center 'B' Room at 1620 to hear what's going on in APRS today and help him celebrate 25 years of gathering.</p>
        <p>Dave is the originator of the idea to hold a Summer Gathering 25 years ago to demonstrate what APRS is and what it can do, and to demonstrate "APRS is not a vehicle tracking system. It is a two-way tactical real-time digital communications system between all assets in a network sharing information about everything going on in the local area........." From Father Bob WB4APR SK the originator of APRS.</p>
        <p>See you at the beach!</p>
        <p>To stay up to date on the latest news, <a href="https://tinyletter.com/nwaprssg">sign up for the newsletter <i class="fas fa-external-link-alt"></i></a>. (We promise, we don't send too many emails!)</p>
      """,
      schedule_content: """
        <div class="">
          <h5>Saturday (6/4):</h5>
          <ul class="schedule-list">
            <li><time>1620:</time> Gather in Seaside Convention Center Room 'B'</li>
          </ul>
        </div>
      """,
      location_content: """
        <div class="flex flex-row gap-4">
          <div>
            <p>
              The Seaside convention center is located in Seaside Oregon.
            </p>
            <p>Address:<br />415 1st Ave, Seaside, OR 97138</p>
            <p>Coordinates:<br />45.99438278051261, -123.92514141225494</p>
          </div>
          <div>
            <div style="text-decoration:none; overflow:hidden;max-width:100%;width:800px;height:500px;"><div id="display-googlemap" style="height:100%; width:100%;max-width:100%;"><iframe style="height:100%;width:100%;border:0;" frameborder="0" src="https://www.google.com/maps/embed/v1/place?q=415+1st+Ave,+Seaside,+OR+97138,+USA&key=AIzaSyBFw0Qbyq9zTFTd-tUY6dZWTgaQzuU17R8"></iframe></div><a class="googlehtml" href="https://dedicatedserver.expert" id="grabmap-authorization">dedicatedserver.expert</a><style>#display-googlemap .text-marker{}.map-generator{max-width: 100%; max-height: 100%; background: none;}</style></div>
            <br />
            <br />
          </div>
        </div>
      """,
    },
    "2023" => %SGPage{
      date: "September 8-10",
      about_header: "26th Annual Summer Gathering",
      about_content: """
        <p>And we're back!</p>
        <p>Summer Gathering is happening once more, hopefully just as good as we all remember! We're still working on putting together the schedule, and we'll keep this page updated with details as they become available.</p>
        <p>As always, the event will be held at <a href="https://valleycamp.org">Valley Camp</a>. For reservations please contact <a href="mailto:info@valleycamp.org">info@valleycamp.org</a>.</p>
        <p>For questions, please contact <a href="mailto:summergathering@wa7vc.org">summergathering@wa7vc.org</a>.</p>
        <p>To stay up to date on the latest news, <a href="https://tinyletter.com/nwaprssg">sign up for the newsletter <i class="fas fa-external-link-alt"></i></a>. (We promise, we don't send too many emails!)</p>
        <p>If you are planning to attend the event please fill out <a href="https://docs.google.com/forms/d/e/1FAIpQLSdGf7MDaeIsDe4nKCKhEcbHStU2M8p78KK7D_qZ-dG5su9Bpg/viewform?usp=sf_link">this RSVP form <i class="fas fa-external-link-alt"></i></a> so we make sure nobody goes hungry!</p>
        <p>
          Event Talk-In Frequency:
          <ul>
            <li>2m Simplex: 146.52 (no tone)</li>
          </ul>
          Other WA7VC local frequencies:
          <ul>
            <li>Echolink: Node 98045 (or Valley Camp)</li>
            <li>IRLP: 7808</li>
            <li>DSTAR: WA7VC B on 440.01250Mhz + 5.000Mhz</li>
            <li>DMR: NorthBend-ValleyCamp 440.7250 + 5.000Mhz (Talkgroup: Local 2)</li>
            <li>APRS: WA7VC-10 Digi-iGate 144.390</li>
          </ul>
        </p>
      """,
      schedule_content: """
        <p>
          We're still working on getting the schedule together! If you have any suggestions for presentations you'd be interested in or would like to give, contact us at <a href="mailto:summergathering@wa7vc.org">summergathering@wa7vc.org</a>!
        </p>
      """,
    },
  }

  defp sg_year(conn, _opts) do
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
        |> put_flash(:error, "No Summer Gathering page for #{requested_year}, showing the next event year (#{latest_year}) instead.")
        |> assign(:load_year, latest_year)
        |> assign(:prev_year, Enum.at(valid_years, Enum.count(valid_years)-2))
        |> assign(:next_year, nil)
    end

    d = @all_data[conn.assigns.load_year]

    {img, alt} = case d.image do
      nil -> {"/images/overhead-640x480.png", "A  drone shot looking down on an event at Valley Camp"}
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
    |> assign(:retrospective_content, d.retrospective_content)
    |> assign(:image, img)
    |> assign(:image_alt, alt)
    |> assign(:meta_attrs, [ %{name: "description", content: d.meta_desc} ])
    |> assign(:cancelled, d.cancelled)
    |> assign(:location, d.location)
    |> assign(:location_content, d.location_content)
  end

  def index(conn, _params) do
    render(conn, "sg_year.html")
  end
end
