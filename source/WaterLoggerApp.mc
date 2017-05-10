using Toybox.Application as App;
using Toybox.WatchUi as Ui;

var metric = null;
var unitText = null;
var unitMultiplier = 0;
var goalTaps = 0;
var tempGoalTaps = 0;
var taps = 0;

class WaterLoggerApp extends App.AppBase {

    function initialize() {
        App.AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    
    	// Get today's date
    	// var dateInfo = Time.Gregorian.info(Time.now, Time.FORMAT_SHORT);
    	// var dateString = Lang.format("$1$$2$$3$", [dateInfo.year, dateInfo.month.format("%02d", dateInfo.day.format("%02d")]);
    	
    	// Get unit choice
    	metric = getProperty(0);
    	if (metric == null) {
    		metric = false;
    	}
     	
    	// Get unit multiplier
    	unitMultiplier = getProperty(1);
    	if (unitMultiplier == null) {
    		unitMultiplier = 4;
    	}
    	    	
    	// Get goal choice
    	goalTaps = getProperty(2);
    	if (goalTaps == null) {
    		goalTaps = 16;
    	}
    	
    	// Get current number of taps
    	taps = getProperty(3);
    	if (taps == null) {
    		taps = 0;
    	}

    		
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    	setProperty(0, metric);
    	setProperty(1, unitMultiplier);
    	setProperty(2, goalTaps);
    	setProperty(3, taps);
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new WaterLoggerView(), new WaterLoggerDelegate() ];
    }

}