//Reads the luminosity and sends it to the uart screen
function convertLux(reg0, reg1) {

    local ch0 = ((reg0[1] & 0xFF) << 8) + (reg0[0] & 0xFF);
    local ch1 = ((reg1[1] & 0xFF) << 8) + (reg1[0] & 0xFF);
    
    local ratio = ch1 / ch0.tofloat();
    local lux = 0.0;
    if (ratio <= 0.5){
        lux = 0.0304*ch0 - 0.062*ch0*math.pow(ratio,1.4);
    } else if( ratio <= 0.61){
        lux = 0.0224 * ch0 - 0.031 * ch1;
    } else if( ratio <= 0.8){
        lux = 0.0128*ch0 - 0.0153*ch1;
    } else if( ratio <= 1.3){
        lux = 0.00146*ch0 - 0.00112*ch1;
    } else {
            Server.log("Invalid lux calculation: " + ch0 + ", " + ch1);
            //return null;
    }

    // Round to 2 decimal places
    lux = (lux*100).tointeger() / 100.0;
    server.log(format("Ratio: %f Lux: %f", ratio, lux));
    Screen.write(format("Lux: %f", lux));
    //return {lux = lux};
}
    
function getLux() {
    //if (!ready) return callback(null);
    //local value;
       
    imp.wakeup(3.0, getLux);
    writeLCD();
    //power up
    if (i2c.write(addr, "\x80\x03") != 0)
    {
        server.log(-1);
    }
         
    imp.sleep(0.45);
    local r0 = i2c.read(addr, "\xAC", 2);
    local r1 = i2c.read(addr, "\xAE", 2);

    if (r0 == null || r1 == null) {
        server.log(-2);
    } 
    else {
        convertLux(r0, r1);
    }
    //power down
    if (i2c.write(addr, "\x80\x00") != 0)
    {
        server.log(-3);
    }
    //server.log(value);
}

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

//impify the i2c address given in the datasheet
local given_i2c_address = 0x39;
addr <- (given_i2c_address << 1);

// Configure i2c bus
i2c <- hardware.i2c89;
hardware.i2c89.configure(CLOCK_SPEED_100_KHZ);

// initialize screen as UART device
Screen <- hardware.uart57;
Screen.configure(9600, 8, PARITY_NONE, 1, NO_RX);
//imp.wakeup(0.5, writeLCD);

// Read luminosity
imp.wakeup(3.0, getLux);

//end