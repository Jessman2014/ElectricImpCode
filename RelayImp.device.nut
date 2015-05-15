// create a global variabled called led and assign pin9 to it
relay1 <- hardware.pin1;
relay3 <- hardware.pin2;
relay5 <- hardware.pin5;
relay7 <- hardware.pin7;
 
// configure led to be a digital output
relay1.configure(DIGITAL_OUT);
relay3.configure(DIGITAL_OUT);
relay5.configure(DIGITAL_OUT);
relay7.configure(DIGITAL_OUT);
//led.write(1);
// create a global variable to store current state of the LED
state <- 0;
//led.write(0);
 
function blink() {
  // invert the value of state:
  // when state = 1, 1-1 = 0
  // when state = 0, 1-0 = 1
  state = 1-state;  
 
  // write current state to led pin
  //relay1.write(state);
  relay3.write(state);
 //relay5.write(state);
 //relay7.write(state);
 
  // schedule imp to wakeup in .5 seconds and do it again. 
  imp.wakeup(1.0, blink);
}

function power(pwr) {
    if (pwr) {
        state <- 1;
        relay3.write(state);
    }
    else {
        state <- 0;
        relay3.write(state);
    }
}

function lookForCommands() {
    agent.send("getFanCommands", counter);
    counter = counter+1;
    imp.wakeup(15.0, lookForCommands);
}

function followCommands(pref) {
    if (pref.auto) {
        //do more complicated instructions
    }
    else {
        power(pref.fanOn);
    }
    //server.log(typeof pref);
}
 
// start the loop
//blink();
power(true);
agent.on("preferences", followCommands);
counter <- 0;
lookForCommands();
