var express = require('express');
var router = express.Router();
var preferenceService = require('../services/preference-service');
var Preferences = require("../models/preferences").Preferences;

router.get('/', function(req, res, next) {
    var pref;
    Preferences.find({})
        .limit(1)
        .sort('-timestamp')
        .exec(function(err, preferences) {
            pref = preferences[0]._doc;
            if(err)
                next(err);
            else {
                if(pref.auto)
                    pref.auto = "checked";
                else
                    pref.auto = "";
                if (pref.fanOn)
                    pref.fanOn = "checked";
                else
                    pref.fanOn = "";
                res.render('preferences/index', pref);
            }
            
        });
    
});

router.post('/', function(req, res, next) {
    preferenceService.updatePreference(req.body, function(err) {
        if(err)
            next(err);
        else
            res.redirect('/preferences');
    })
})

module.exports = router;