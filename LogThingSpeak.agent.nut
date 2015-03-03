local thingSpeakUrl = "http://api.thingspeak.com/update";

local headers = {
  "Content-Type" : "application/x-www-form-urlencoded",
  "X-THINGSPEAKAPIKEY" : "H6CISC0ES71Z8QI4"
};

local field = "field1";

function httpPostToThingSpeak (data) {
  local request = http.post(thingSpeakUrl, headers, data);
  local response = request.sendsync();
  return response;
}
 
device.on("sendLux", function(input) {
  local response =  httpPostToThingSpeak(field+"="+input);
  server.log(response.body);
});
