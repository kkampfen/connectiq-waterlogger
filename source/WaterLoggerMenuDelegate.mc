using Toybox.WatchUi as Ui;

class WaterLoggerMenuDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenuItem(item) {
    	if (item == :History) {
    		Ui.pushView(new HistoryView(), new HistoryDelegate(), Ui.SLIDE_IMMEDIATE);
    	}
    	
        if (item == :Reset) {
            gTaps = 0;
        }
        
        if (item == :SetGoal) {
            Ui.pushView(new GoalSetter(), new GoalSetterDelegate(), Ui.SLIDE_IMMEDIATE);       
        }
        
        if (item == :SwitchUnits) {
        	if (!gIsMetric) {
        		gIsMetric = true;
        		gUnitMultiplier = 125;
        	} else {
        		gIsMetric = false;
        		gUnitMultiplier = 4;
        	}
        }
    }
}