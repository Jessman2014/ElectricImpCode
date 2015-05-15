var express = require('express');
var router = express.Router();
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
                res.json(pref);
            }
        });
});

module.exports = router;