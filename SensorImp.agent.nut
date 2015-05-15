local thingSpeakUrl = "http://api.thingspeak.com/update";

local headers = {
  "Content-Type" : "application/x-www-form-urlencoded",
  "X-THINGSPEAKAPIKEY" : "H6CISC0ES71Z8QI4"
};

local field1 = "field1";
local field2 = "field2";
local field3 = "field3";

function httpPostToThingSpeak (data) {
  local request = http.post(thingSpeakUrl, headers, data);
  local response = request.sendsync();
  return response;
}
 
device.on("sendSoilMoist", function(input) {
  local response =  httpPostToThingSpeak(field3 + "=" + input);
  server.log(response.body);
});

device.on("sendTemp", function(input) {
  local response =  httpPostToThingSpeak(field2 + "=" + input);
  server.log(response.body);
});

device.on("sendHum", function(input) {
  local response =  httpPostToThingSpeak(field1 + "=" + input);
  server.log(response.body);
});
