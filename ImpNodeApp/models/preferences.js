var mongoose = require("mongoose");
var Schema = mongoose.Schema;

var preferncesSchema = new Schema({
    maxTemp: Number,
    minTemp: Number,
    maxHumidity: Number,
    minHumidity: Number,
    auto: Boolean,
    fanOn: Boolean
});

var Preferences = mongoose.model('Preferences', preferncesSchema);

module.exports = {
    Preferences: Preferences
};