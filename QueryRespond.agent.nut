// Log the URLs we need
server.log("Send message to: " + http.agenturl() + "?message=");
 
function requestHandler(request, response) {
  try {
    // check if the user sent message as a query parameter
    if ("message" in request.query) {
      local message = request.query.message;
      // if message is in the path then get its value
      if (message != "" && message.len() < 12) {
        // pass the message to the imp to print
        device.send("message", message);
      }
    }
    // send a response back saying everything was OK.
    response.send(200, "OK");
  } catch (ex) {
    response.send(500, "Internal Server Error: " + ex);
  }
}
 
// register the HTTP handler
http.onrequest(requestHandler);
