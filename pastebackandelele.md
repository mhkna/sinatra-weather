
<h2>Results for <%= @location.formatted_address %></h2>

<div class="full-container">
  <div class="row">
    <div class="col-8">
      <h4>Today</h4>
      <div>
        <p><%= DateTime.now.strftime('%A, %b %m, %Y') %></p>
      </div>
      <canvas id="<%= @location.today_icon %>" width="128" height="128"></canvas>
      <h4><%= @location.today_summary %></h4>
      <p><%= @location.today_details %></p>

    </div>

    <div class="col-4">
      <h4>Currently</h4>
      <p><%= @location.now_weather %></p>
    </div>
  </div>

  <div class="row">
    <% @location.future_weather.each do |day| %>
      <div class="col-4">
        <div class="future-day-contain">
          <div><%= DateTime.strptime(day[0].to_s, '%s').strftime('%A') %></div>
          <div><%= day[1][0...-1] %> with a high of <%= day[2].round %> degrees.</div>
        </div>
      </div>
    <% end %>
  </div>

  <div class="row">
    <div class="col-12">
      <h4><%= DateTime.now.strftime('%B %-d') %> historical</h4>
      <%= line_chart [
        {name: "High", data: @location.past_high_temp},
        {name: "Low", data: @location.past_low_temp}
      ], colors: ["red", "blue"] %>
    </div>
  <div>


</div>

<script src="https://rawgithub.com/darkskyapp/skycons/master/skycons.js"></script>
<script src="/JS/skycons.js"></script>
