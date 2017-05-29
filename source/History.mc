using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class HistoryView extends Ui.View {
	
	// Layout vars
	var dcHeight = 0;
	var titleRow = 0;
	var countRow = 0;
	var goalRow = 0;
	var dateRow = 0;
	var bottomRow = 0;
	var dcWidth = 0;
	var columnWidth = 0;
	var legendColumn = 0;
	var logo_tiny = null;
	
	function initialize() {
		View.initialize();
		logo_tiny = Ui.loadResource(Rez.Drawables.logo_tiny);
	}
	
	function onLayout(dc) {
		dcHeight = dc.getHeight();
		titleRow = 10;
		countRow = dcHeight / 3 - 10;
		goalRow = dcHeight / 2 - 10;
		dateRow = dcHeight / 3 * 2 - 10;
		bottomRow = dcHeight / 5 * 4;
		dcWidth = dc.getWidth();
		columnWidth = dcWidth / 7;
		legendColumn = 10;
	}
	
	function onShow() {
	}
	
	function onUpdate(dc) {
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    	dc.clear();
    	
    	var currentColumn = columnWidth;
    	
    	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
    	dc.drawText(dcWidth / 2, titleRow, Gfx.FONT_SMALL, "History", Gfx.TEXT_JUSTIFY_CENTER);
    	
    	dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
    	dc.drawBitmap(15, countRow, logo_tiny);
    	
    	dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
    	dc.drawText(legendColumn, goalRow, Gfx.FONT_TINY, "Goal", Gfx.TEXT_JUSTIFY_LEFT);

    	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
    	dc.drawText(dcWidth / 2, bottomRow, Gfx.FONT_TINY, "Date", Gfx.TEXT_JUSTIFY_CENTER);
    	    	 	
    	if ((dcHeight > dcWidth && !gIsMetric) || (dcHeight <= dcWidth && gIsMetric)) {
    		currentColumn = dcWidth / 5;
    		for (var i = 2; i < gDateArray.size(); i++) {
    			dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
    			dc.drawText(currentColumn * i, countRow, Gfx.FONT_TINY, gCountArray[i], Gfx.TEXT_JUSTIFY_CENTER);
    			dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
    			dc.drawText(currentColumn * i, goalRow, Gfx.FONT_TINY, gGoalArray[i], Gfx.TEXT_JUSTIFY_CENTER);
    			dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
    			dc.drawText(currentColumn * i, dateRow, Gfx.FONT_TINY, gDateArray[i], Gfx.TEXT_JUSTIFY_CENTER);
    		}
    	} else if (dcHeight > dcWidth && gIsMetric) {
    		currentColumn = dcWidth / 4;
    		for (var i = 3; i < gDateArray.size(); i++) {
    			dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
    			dc.drawText(currentColumn * (i - 1), countRow, Gfx.FONT_TINY, gCountArray[i], Gfx.TEXT_JUSTIFY_CENTER);
    			dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
    			dc.drawText(currentColumn * (i - 1), goalRow, Gfx.FONT_TINY, gGoalArray[i], Gfx.TEXT_JUSTIFY_CENTER);
    			dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
    			dc.drawText(currentColumn * (i - 1), dateRow, Gfx.FONT_TINY, gDateArray[i], Gfx.TEXT_JUSTIFY_CENTER);
    		}
    	} else {    	
    		for (var i = 0; i < gDateArray.size(); i++) {
    			dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
    			dc.drawText(currentColumn * (i + 2), countRow, Gfx.FONT_TINY, gCountArray[i], Gfx.TEXT_JUSTIFY_CENTER);
    			dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
    			dc.drawText(currentColumn * (i + 2), goalRow, Gfx.FONT_TINY, gGoalArray[i], Gfx.TEXT_JUSTIFY_CENTER);
    			dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
    			dc.drawText(currentColumn * (i + 2), dateRow, Gfx.FONT_TINY, gDateArray[i], Gfx.TEXT_JUSTIFY_CENTER);
    		}
    	}		
	}
	
	function onHide() {
	}
}

class HistoryDelegate extends Ui.InputDelegate {
	
	function initialize() {
		InputDelegate.initialize();
	}
}