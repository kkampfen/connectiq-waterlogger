using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Time as Time;

var gIsMetric = null;
var gUnitText = null;
var gUnitMultiplier = 0;
var gGoalTaps = 0;
var gTaps = 0;
var gLastSaveDate = 0;
var gDateArray = new [0];
var gGoalArray = new [0];
var gCountArray = new [0];

class WaterLoggerApp extends App.AppBase {

    function initialize() {
        App.AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    
    	// Get today's date
    	var today = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
    	
    	// Get unit choice
    	gIsMetric = getProperty(0);
    	if (gIsMetric == null) {
    		gIsMetric = false;
    	}
     	
    	// Get unit multiplier
    	gUnitMultiplier = getProperty(1);
    	if (gUnitMultiplier == null) {
    		gUnitMultiplier = 4;
    	}
    	    	
    	// Get goal choice
    	gGoalTaps = getProperty(2);
    	if (gGoalTaps == null) {
    		gGoalTaps = 16;
    	}
    	
    	// Get current number of taps
    	gTaps = getProperty(3);
    	if (gTaps == null) {
    		gTaps = 0;
    	}
    	
    	// Get most recent save day
    	gLastSaveDate = getProperty(4);
    	if (gLastSaveDate == null) {
    		gLastSaveDate = today.day;
    	}
    	
    	// Get history arrays if they exist
    	if (getProperty(5) != null) {
    		gDateArray = getProperty(5);
    	}
    	if (getProperty(6) != null) {
    		gGoalArray = getProperty(6);
    	}
    	if (getProperty(7) != null) {
    		gCountArray = getProperty(7);
    	}
    	
    	// Check if new day since last save
    	var todayDate = today.day;

    	// If not, save previous data and reset count    	
    	if (todayDate != gLastSaveDate) {
    		  	
    		// Save previous data to history arrays
    		gDateArray.add(gLastSaveDate);
    		gGoalArray.add(gGoalTaps * gUnitMultiplier);
    		gCountArray.add(gTaps * gUnitMultiplier);
    		
    		// Limit history arrays to five entries
    		if (gDateArray.size() == 6) {
    			gDateArray.remove(gDateArray[0]);
    			gGoalArray.remove(gGoalArray[0]);
    			gCountArray.remove(gCountArray[0]);
    		}    		
 
 			// Save history arrays to device storage
    		setProperty(5, gDateArray);
    		setProperty(6, gGoalArray);
    		setProperty(7, gCountArray);
    		
    		// Reset for new day
    		gTaps = 0;
    		gLastSaveDate = todayDate;
    	}    		
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    	// Save current data to device storage
    	setProperty(0, gIsMetric);
    	setProperty(1, gUnitMultiplier);
    	setProperty(2, gGoalTaps);
    	setProperty(3, gTaps);
    	setProperty(4, gLastSaveDate);
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new WaterLoggerView(), new WaterLoggerDelegate() ];
    }

}

//class History {
//	function initialize(mDate, mGoal, mCount) {
//	 	date = mDate;
//	 	goal = mGoal;
//	 	count = mCount;
//	}
	
//	var date;
//	var goal;
//	var count;
//}