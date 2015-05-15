var Preferences = require("../models/preferences").Preferences;

exports.addPreference = function(pref, next) {
    var newPref = new Preferences({
         maxTemp: pref.maxTemp,
        minTemp: pref.minTemp,
        maxHumidity: pref.maxHumidity,
        minHumidity: pref.minHumidity,
        auto: pref.auto,
        fanOn: pref.fanOn
    });
    newPref.save(function(err){
        if(err){
            return next(err);
        }
        next(null);
    });
};

exports.getPreference = function() {
    var pref;
    Preferences.find({})
        .limit(1)
        .sort('-timestamp')
        .exec(function(err, preferences) {
            pref = preferences[0]._doc;
            return pref;
        });
};

exports.updatePreference = function(pref, next) {
    if (!pref.auto)
        pref.auto = false;
    if (!pref.fanOn)
        pref.fanOn = false;
    var newStr = JSON.stringify(pref);
    Preferences.update({},{$set:pref},{},function(err) {
        if (err)
            console.log(err);
    });
    next(null);
};