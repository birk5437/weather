$(document).ready(function(){
  console.log("derp");

  var url = "http://free.worldweatheronline.com/feed/weather.ashx?q=" + $("#zip").html() + "&format=json&key=55d99285d6001415122608";

  $.ajax({
    url: url,
    method: "POST"
  }).done(function(data) {
    $("#content").html(data)
  });

});