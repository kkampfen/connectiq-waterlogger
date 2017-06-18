using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

var i = 0;
var min = 0;
var max = 0;

class HistoryView extends Ui.View {
	
	// Layout vars
	var dcHeight = 0;
	var dcWidth = 0;
	var titleRow = 0;
	var percentReached = 1.0;
	var percentRow = 0;
	var percentColumn = 0;
	var dateRow = 0;
	var countRow = 0;
	var tempMonthArray;
	var tempDateArray;
	var tempGoalArray;
	var tempCountArray;
	var firstSeparator = 0;
	var secondSeparator = 0;
	var controlsRow = 0;
	var deviceSettings = null;
	var canvasTall = false;
	var canvasSemiRound = false;
	
	// Layout elements
	var nextButton = null;
	var prevButton = null;
	
	function initialize() {
		View.initialize();
		tempMonthArray = gMonthArray.reverse();
		tempDateArray = gDateArray.reverse();
		tempGoalArray = gGoalArray.reverse();
		tempCountArray = gCountArray.reverse();
		max = tempDateArray.size() - 1;
	}
	
	function onLayout(dc) {
		deviceSettings = Sys.getDeviceSettings();
		if (deviceSettings.screenShape == 2) {
			canvasSemiRound = true;
		}
		
		// Set layout vars
		dcHeight = dc.getHeight();
		dcWidth = dc.getWidth();
		titleRow = 10;
		percentRow = dcHeight / 4;
		percentColumn = dcWidth / 3 * 2;
		countRow = dcHeight / 2 + 15;
		dateRow = dcHeight - 35;
		firstSeparator = dcWidth / 3;
		secondSeparator = dcWidth / 3 * 2;
		
		// Determine if device has touch screen
		if (deviceSettings.isTouchScreen) {
			nextButton = Ui.loadResource(Rez.Drawables.nextButton);
			prevButton = Ui.loadResource(Rez.Drawables.prevButton);
			controlsRow = dcHeight - 40;
		}
	}
	
	function onShow() {
	}
	
	function onUpdate(dc) {
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    	dc.clear();
    	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
    	
		// Draw title to screen
    	dc.drawText(dcWidth / 2, titleRow, Gfx.FONT_SMALL, "History", Gfx.TEXT_JUSTIFY_CENTER);
		
		if (tempCountArray.size() < 1) {
			dc.drawText(dcWidth / 2, dcHeight / 3, Gfx.FONT_LARGE, "No data\nto display", Gfx.TEXT_JUSTIFY_CENTER);
		} else {
			// Draw goal percentage to screen
			percentReached = (tempCountArray[i] * 100) / tempGoalArray[i];
			dc.drawText(percentColumn - 5, percentRow, Gfx.FONT_NUMBER_HOT, percentReached + "%", Gfx.TEXT_JUSTIFY_RIGHT);
			dc.drawText(percentColumn + 5, percentRow, Gfx.FONT_SMALL, "of\ngoal", Gfx.TEXT_JUSTIFY_LEFT);

			// Draw count to screen
			dc.drawText(dcWidth / 2 , countRow, Gfx.FONT_LARGE, tempCountArray[i] + " " + gUnitText, Gfx.TEXT_JUSTIFY_CENTER);		
		
			// Draw date to screen
			dc.drawText(dcWidth / 2, dateRow, Gfx.FONT_MEDIUM, tempDateArray[i] + " " + tempMonthArray[i], Gfx.TEXT_JUSTIFY_CENTER);
			
					// Draw prev and next buttons to screen		
			if (deviceSettings.isTouchScreen) {
				if (canvasSemiRound) {
					dc.drawBitmap((firstSeparator - prevButton.getWidth()), controlsRow, prevButton);
					dc.drawBitmap(secondSeparator, controlsRow, nextButton);			
				} else {
					dc.drawBitmap((firstSeparator - prevButton.getWidth()) /2, controlsRow, prevButton);
					dc.drawBitmap((dcWidth - secondSeparator - nextButton.getWidth()) / 2 + secondSeparator, controlsRow, nextButton);
				}
			}
		}
	}
	
	function onHide() {
	}
}

class HistoryDelegate extends Ui.InputDelegate {

	var deviceSettings = null;
	var screenWidth = null;
	var firstSeparator = 0;
	var secondSeparator = 0;
		
	function initialize() {
		InputDelegate.initialize();
		deviceSettings = Sys.getDeviceSettings();
		screenWidth = deviceSettings.screenWidth;
		firstSeparator = screenWidth / 3;
		secondSeparator = screenWidth / 3 * 2;
	}
	
	function onBack() {
		Ui.popView(Ui.SLIDE_IMMEDIATE);
		return true;
	}
	
    function onTap(evt) {
  	var xyTap = evt.getCoordinates();
  		if (xyTap[0] < firstSeparator) {
 			nextDate();
 			return true;
 		} else if (xyTap[0] > secondSeparator) {
 			prevDate();
 			return true;
 		}
 		return false;
   	}
	
	function onKey(evt) {
       	var key = evt.getKey();
       	if (key == Ui.KEY_ESC) {
       		Ui.popView(Ui.SLIDE_IMMEDIATE);
       		return true;
       	}
       	if (key == Ui.KEY_UP) {
			prevDate();
       		return true;
       	}
       	if (key == Ui.KEY_DOWN) {
			nextDate();
       		return true;
       	}
       	return false;
    }
    
    function nextDate() {
		if (i < max) {
       		i++;
       	} else {
       		i = min;
       	}
       	Ui.requestUpdate();
    }
    
    function prevDate() {
		if (i > 0) {
       		i--;
       	} else {
       		i = max;
       	}
       	Ui.requestUpdate();
    }
}