out <- hardware.pin5;
rv <- hardware.pin2;
tmp <- hardware.pin1;
zeroWindAdjustment <- 0.0;

function setup() {
    out.configure(ANALOG_IN);
    rv.configure(ANALOG_IN);
    tmp.configure(ANALOG_IN);
    imp.wakeup(10.0, loop);
}

function loop() {
    local TMP_Therm_ADunits = tmp.read();
    local RV_Wind_ADunits = rv.read();
    //server.log(TMP_Therm_ADunits);
    //server.log(RV_Wind_ADunits);
    local RV_Wind_Volts = (RV_Wind_ADunits *  0.0048828125);
    local TempCtimes100 = 0.005 * TMP_Therm_ADunits * TMP_Therm_ADunits - 16.862 * TMP_Therm_ADunits + 9075.4;
    local zeroWind_ADunits = -0.0006 * TMP_Therm_ADunits * TMP_Therm_ADunits + 1.0727 * TMP_Therm_ADunits + 47.172;
    local zeroWind_volts = (zeroWind_ADunits * 0.0048828125 - zeroWindAdjustment);
    local tmpFloat = ((RV_Wind_Volts - zeroWind_volts)/0.2300);
    local WindSpeed_MPH = math.pow(tmpFloat.tointeger() , 2.7265);
    //server.log("TMP volts " + (TMP_Therm_ADunits * 0.0048828125));
    //server.log("RV volts " + RV_Wind_Volts);
    //server.log("TempC*100 " + TempCtimes100);
    //server.log("ZeroWind volts " + zeroWind_volts);
    //server.log("Windspeed MPH " + WindSpeed_MPH);
    imp.wakeup(5.0, loop);
}

setup();
