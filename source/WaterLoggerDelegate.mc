using Toybox.WatchUi as Ui;
using Toybox.Attention as Att;

class WaterLoggerDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        Ui.BehaviorDelegate.initialize();
    }
        
    function onTap(evt) {
    	takeDrink();
    	return true;
    }

    function onKey(evt) {
        var key = evt.getKey();
        if (key == Ui.KEY_ENTER || key == Ui.KEY_START) {
            takeDrink();
            return true;
        } else if (key == Ui.KEY_MENU) {
        	onMenu();
        	return true;
        }
        return false;
    }
    
    function takeDrink() {
    	gTaps++;
    	checkGoal();
    	Ui.requestUpdate();
    }
    
    function onMenu() {
        Ui.pushView(new Rez.Menus.MenuLayout(), new WaterLoggerMenuDelegate(), Ui.SLIDE_RIGHT);
        return true;
    }
    
 	function checkGoal() {
		if (gTaps > 0 && gTaps % gGoalTaps == 0) {
			if (Att has :vibrate) {
		 		var vibe = [ new Att.VibeProfile(50, 1000) ];
				Att.vibrate(vibe);
			}
			
			if (Att has :playTone) {
				Att.playTone(4);
			}
		}
	}
}