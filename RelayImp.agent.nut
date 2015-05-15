
function returnFanCommands(command) {
    local body = http.jsondecode(command.body);
    server.log(command.statuscode + ", " + command.body);
   device.send("preferences", body);
    //server.log(auto + ", " + fanOn);
}

function getFanCommands(counter) {
    server.log(counter);
    local headers = {};
    headers["Cache-Control"] <- "no-cache";
    local request = http.get("https://mean-web-api-v1-jessman2014.c9.io/imp", headers);
    request.sendasync(returnFanCommands);
}

device.on("getFanCommands", getFanCommands);