using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class WaterLoggerView extends Ui.View {
	
	// Layout vars
	var dcHeight = 0;
	var titleRow = 0;
	var countRow = 0;
	var logoRow = 0;
	var goalRow = 0;
	var progBarRow = 0;
	var dcWidth = 0;
	var logoCol = 0;
	var countCol = 0;
	var canvasShape = 0;
	
	// Layout elements
	var baseBarWidth = 0;
	var progBarWidth = 1.0;
	var progPercent = 1.0;
	var count = 0;
	var logo = null;
	var logoWidth = 0;
	var goalText = null;
	var endAngle = 1.0;
	
	// Screen variables
	var canvasRound = false;
	var canvasSemiRound = false;
	var canvasTall = false;
	var canvasRect = false;
	var canvasRectTall = false;
	
    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
    
		// Base layout variables
		dcHeight = dc.getHeight();
        titleRow = 10;
        countRow = dcHeight / 3;
		countCol = dcWidth / 4 * 3;
        progBarRow = dcHeight - 25;
        goalRow = dcHeight - 25;
        dcWidth = dc.getWidth();
        logoCol = 5;
        countCol = dcWidth - 40;
        logo = Ui.loadResource(Rez.Drawables.logo);
        logoWidth = logo.getWidth();
        
        // Determine and set screen shape, orientagion, and size
        var deviceSettings = Sys.getDeviceSettings();
        canvasShape = deviceSettings.screenShape;
        
        if (dcHeight > dcWidth) {
        	canvasTall = true;
        }
        
        if (canvasShape == 1) {
        	canvasRound = true;
        } else if (canvasShape == 2) {
        	canvasSemiRound = true;
        } else if (canvasShape == 3 && canvasTall) {
        	canvasRectTall = true;
        } else {
        	canvasRect = true;
        }
    } 

    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
    
    	// Clear the canvas
    	dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
    	dc.clear();
				
		// Set values for element variables
		count = taps * unitMultiplier;
		progPercent = 1.0 * taps / goalTaps;
		unitText = "oz";
		if (metric == 1) {
			unitText = "ml";
		} 
		goalText = "Goal " + (goalTaps * unitMultiplier) + " " + unitText;
		
		// Create layouts for the various screen shapes and sizes

		// Round (1) Devices
		if (canvasRound) {
			
			// Set shape-specifc layout positions
			if (dcHeight < 225) {
				countRow = dcHeight / 3;
			}
			logoRow = countRow + 5;
			logoCol = 20;
			goalRow = dcHeight / 4 * 3 - 10;
			
			// Draw base arc
			dc.setPenWidth(10);
			dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK);
			dc.drawArc(dcWidth / 2, dcHeight / 2, dcWidth / 2 - 10, Gfx.ARC_COUNTER_CLOCKWISE, 190, 350);
			
			// Calculate progress arc size
			if (taps > 0) {
				endAngle = 350;
				if (taps < goalTaps) {
					endAngle = 190.0 + (160.0 * progPercent);
				}
				
				// Draw progress arc
				dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_BLUE);
				dc.drawArc(dcWidth / 2, dcHeight / 2, dcWidth / 2 - 10, Gfx.ARC_COUNTER_CLOCKWISE, 190, endAngle); 
			}
		}
		
		if (canvasSemiRound) {
			
			// Set shape-specific layout positions
			logoRow = countRow + 20;
			logoCol = 25;
			
			// Set progress bar width
			baseBarWidth = dcWidth / 2;
			progBarWidth = baseBarWidth;
		}
		
		if (canvasRectTall) {
			
			// Set shape-specific layout positions
			logoRow = dcHeight / 3 * 2 - 5;
			logoCol = (dcWidth - logoWidth) / 2;
			
			// Set progress bar width
			baseBarWidth = dcWidth - 20;
			progBarWidth = baseBarWidth;
		}		
		
		if (canvasRect) {
			
			// Set shape-specific layout positions
			logoRow = dcHeight / 3 + 10;
			logoCol = 10;
			
			// Set progress bar width
			baseBarWidth = dcWidth - 10;
			progBarWidth = baseBarWidth;
		}
		
		if (canvasSemiRound || canvasRectTall || canvasRect) {
			
			// Draw base bar
			dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_LT_GRAY);
			dc.fillRectangle((dcWidth - baseBarWidth) / 2, progBarRow, progBarWidth, 20);
        	
        	// Draw progress bar
    		if (taps > 0) {
				if (taps < goalTaps) {
					progBarWidth = 1.0 * progPercent * progBarWidth;
				}
				dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_BLUE);
        		dc.fillRectangle((dcWidth - baseBarWidth) / 2, progBarRow, progBarWidth, 20);
			}
		} 
				
		// Draw title to screen
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
		dc.drawText(dcWidth / 2, titleRow, Gfx.FONT_SMALL, "WaterLogger", Gfx.TEXT_JUSTIFY_CENTER);

		// Draw count text to screen
		if (dcWidth < 205 || canvasSemiRound) {
			dc.drawText(countCol, countRow, Gfx.FONT_NUMBER_HOT, count, Gfx.TEXT_JUSTIFY_RIGHT);
		} else {
			dc.drawText(countCol, countRow, Gfx.FONT_NUMBER_THAI_HOT, count, Gfx.TEXT_JUSTIFY_RIGHT);
		}
		
		// Draw unit text to screen	
		dc.drawText(countCol + 5, countRow, Gfx.FONT_MEDIUM, unitText, Gfx.TEXT_JUSTIFY_LEFT);
		
		// Draw logo to screen
		dc.drawBitmap(logoCol, logoRow, logo);
		
		// Draw goal text to screen
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		dc.drawText(dcWidth / 2, goalRow, Gfx.FONT_SYSTEM_TINY, goalText, Gfx.TEXT_JUSTIFY_CENTER);
    }

    function onHide() {
    }
}