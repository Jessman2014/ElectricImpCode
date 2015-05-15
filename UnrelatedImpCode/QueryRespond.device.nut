//Takes the message from the url query and logs it to the uart screen
function writeLCD() {
    //imp.wakeup(5.0, writeLCD);
    server.log("writing");
    Screen.write(254);
    Screen.write(128);
    Screen.write("                "); // clear display
    Screen.write("                ");

    Screen.write(254); // move cursor to beginning of first line
    Screen.write(128);
    //Screen.write("Hello, world!");
}

//MAIN

// initialize screen as UART device
Screen <- hardware.uart57;
Screen.configure(9600, 8, PARITY_NONE, 1, NO_RX);

// display message
function writeMessage(message) {
	server.log("Writing message: " + message);
	writeLCD();
	Screen.write(message);
}

agent.on("message", writeMessage);

//end