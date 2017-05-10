using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class GoalSetter extends Ui.View {
	
	// Layout vars
	var dcHeight = 0;
	var titleRow = 0;
	var goalRow = 0;
	var dcWidth = 0;
	var goalCol = 0;
	var firstSeparator = 0;
	var secondSeparator = 0;
	var controlsRow = 0;
	var deviceSettings = null;
	var canvasSemiRound = false;
	var canvasRectTall = false;
	
	// Layout elements
	var upButton = null;
	var downButton = null;
	
	// Goal vars
	var tempGoalCount = 0;
	
	function initialize() {
		View.initialize();
	}
	
	function onLayout(dc) {
		deviceSettings = Sys.getDeviceSettings();
		dcHeight = dc.getHeight();
		titleRow = 10;
		goalRow = dcHeight / 3;
		dcWidth = dc.getWidth();
		goalCol = dcWidth / 4 * 3;
		firstSeparator = dcWidth / 3;
		secondSeparator = dcWidth / 3 * 2;
		tempGoalTaps = goalTaps;
		
		if (deviceSettings.screenShape == 2) {
			canvasSemiRound = true;
		}
		
		if (deviceSettings.screenShape == 3 && dcWidth < dcHeight) {
			canvasRectTall = true;
		}
		
		if (deviceSettings.isTouchScreen) {
			upButton = Ui.loadResource(Rez.Drawables.upButton);
			downButton = Ui.loadResource(Rez.Drawables.downButton);
			controlsRow = dcHeight - 30;
		}
	}
	
	function onShow() {
	}
	
	function onUpdate(dc) {
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    	dc.clear();		
		
		tempGoalCount = tempGoalTaps * unitMultiplier;
		
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
		dc.drawText(dcWidth / 2, titleRow, Gfx.FONT_SMALL, "Set Goal", Gfx.TEXT_JUSTIFY_CENTER);
		// Draw count to screen
		if (dcWidth < 205 || canvasSemiRound) {
			dc.drawText(goalCol, goalRow, Gfx.FONT_NUMBER_HOT, tempGoalCount, Gfx.TEXT_JUSTIFY_RIGHT);
		} else {
			dc.drawText(goalCol, goalRow, Gfx.FONT_NUMBER_THAI_HOT, tempGoalCount, Gfx.TEXT_JUSTIFY_RIGHT);
		}
		dc.drawText(goalCol + 5, dcHeight / 3, Gfx.FONT_MEDIUM, unitText, Gfx.TEXT_JUSTIFY_LEFT);
		
		if (deviceSettings.isTouchScreen) {
			if (canvasSemiRound) {
				dc.drawBitmap((firstSeparator - downButton.getWidth()), controlsRow, downButton);
				dc.drawText(dcWidth / 2, controlsRow, Gfx.FONT_MEDIUM, "OK", Gfx.TEXT_JUSTIFY_CENTER);
				dc.drawBitmap(secondSeparator, controlsRow, upButton);			
			} else {
				dc.drawBitmap((firstSeparator - downButton.getWidth()) /2, controlsRow, downButton);
				dc.drawText(dcWidth / 2, controlsRow, Gfx.FONT_MEDIUM, "OK", Gfx.TEXT_JUSTIFY_CENTER);
				dc.drawBitmap((dcWidth - secondSeparator - upButton.getWidth()) / 2 + secondSeparator, controlsRow, upButton);
			}
		}
	}
	
	function onHide() {
	}
}

class GoalSetterDelegate extends Ui.InputDelegate {

	var deviceSettings = null;
	var screenWidth = null;
	var dcWidth = 0;
	var dcHeight = 0;
	var firstSeparator = 0;
	var secondSeparator = 0;
	
	function initialize() {
		InputDelegate.initialize();
		deviceSettings = Sys.getDeviceSettings();
		screenWidth = deviceSettings.screenWidth;
		firstSeparator = screenWidth / 3;
		secondSeparator = screenWidth / 3 * 2;
	}
	
	function onKey(evt) {
       	var key = evt.getKey();
       	if (key == Ui.KEY_UP) {
    		tempGoalUp();
    		return true;
       	} else if (key == Ui.KEY_DOWN) {
       		tempGoalDown();
       		return true;
       	} else if (key == Ui.KEY_ENTER || key == Ui.KEY_START) {
           	goalTaps = tempGoalTaps;
           	Ui.popView(Ui.SLIDE_IMMEDIATE);
           	return true;
       	} else if (key == Ui.KEY_ESC) {
       		Ui.popView(Ui.SLIDE_IMMEDIATE);
       		return true;
       	}
       	return false;
    }
        
    function onTap(evt) {
  	var xyTap = evt.getCoordinates();
  		if (xyTap[0] < firstSeparator) {
 			tempGoalDown();
 			return true;
 		} else if (xyTap[0] > firstSeparator && xyTap[0] < secondSeparator) {
 			goalTaps = tempGoalTaps;
 			Ui.popView(Ui.SLIDE_IMMEDIATE);
 			return true;
 		} else if (xyTap[0] > secondSeparator) {
 			tempGoalUp();
 			return true;
 		}
 		return false;
   	}
   	
   	function tempGoalDown() {
   		if (tempGoalTaps > 1) {
   			tempGoalTaps--;
   		} else {
   			tempGoalTaps = 64;
   		}
   		Ui.requestUpdate();
   	}
   	
   	function tempGoalUp() {
   		if (tempGoalTaps < 64) {
   			tempGoalTaps++;
   		} else {
   			tempGoalTaps = 1;
   		}
   		Ui.requestUpdate();
   	}
}

