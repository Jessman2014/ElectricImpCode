HTDU21D_ADDRESS <- 0x40;  //Unshifted 7-bit I2C address for the sensor
TRIGGER_TEMP_MEASURE_NOHOLD <- "\xF3";
TRIGGER_HUMD_MEASURE_NOHOLD <- "\xF5";
SHIFTED_DIVISOR <- 0x988000;

function loop() {
    agent.send("sendSoilMoist", soilIn.read());
    imp.sleep(30.0);
    readTemp();
    imp.sleep(30.0);
    readHumidity();
    imp.sleep(30.0);
    loop();
}

function readTemp () {
    i2c.write(addr, TRIGGER_TEMP_MEASURE_NOHOLD);
    imp.sleep(0.05);
    local v = i2c.read(addr,"",3);
    local msb = v[0];
    local lsb = v[1];
    local crc = v[2];
    local rawTemp = msb << 8;
    rawTemp = rawTemp | lsb;
    rawTemp = rawTemp & 0xFFFC;
    local tmpTemp = rawTemp / 65536.0;
    local realTemp = (-46.85 + (175.72 * tmpTemp));
    agent.send("sendTemp", realTemp);
}

function readHumidity() {
    i2c.write(addr, TRIGGER_HUMD_MEASURE_NOHOLD);
    imp.sleep(0.016);
    local v = i2c.read(addr,"",3);
    local msb = v[0];
    local lsb = v[1];
    local crc = v[2];
    local rawHum = msb << 8 | lsb;
    rawHum = rawHum & 0xFFF0;
    local tempRH = rawHum / 65536.0;
    local rh = -6 + (125 * tempRH);
    agent.send("sendHum", rh);
}

function checkCRC(message, crc) {
    local remainder = message << 8;
    server.log(remainder);
    remainder = remainder | crc;
    server.log(remainder);
    local divisor = SHIFTED_DIVISOR;
    for(local i = 0; i < 16; i += 1) {
        server.log(remainder);
        server.log(typeof remainder);
        local temp = remainder << (23-i);
        server.log("temp " + temp);
        temp = temp & 1;
        server.log("temp " + temp);
        if(temp) {
            remainder = math.pow(remainder,divisor);
        }
        divisor = divisor >> 1;
        server.log("divisor" + divisor);
    }
}

// Configure i2c bus
i2c <- hardware.i2c89;
i2c.configure(CLOCK_SPEED_400_KHZ);

soilIn <- hardware.pin7;
soilIn.configure(ANALOG_IN);

//impify the i2c address given in the datasheet
addr <- (HTDU21D_ADDRESS << 1);
//server.log(addr);
loop();
