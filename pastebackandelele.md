<div class="row">
  <div class="col">
    <h4><%= DateTime.now.strftime('%B %-d') %> historical</h4>
    <%= line_chart [
      {name: "High", data: @location.past_high_temp},
      {name: "Low", data: @location.past_low_temp}
    ], colors: ["red", "blue"] %>
  </div>
<div>
