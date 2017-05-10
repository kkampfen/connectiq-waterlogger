using Toybox.WatchUi as Ui;

class WaterLoggerMenuDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :Reset) {
            taps = 0;
        }
        
        if (item == :SetGoal) {
            Ui.pushView(new GoalSetter(), new GoalSetterDelegate(), Ui.SLIDE_IMMEDIATE);       
        }
        
        if (item == :SwitchUnits) {
        	if (!metric) {
        		metric = true;
        		unitMultiplier = 125;
        	} else {
        		metric = false;
        		unitMultiplier = 4;
        	}
        }
    }
}