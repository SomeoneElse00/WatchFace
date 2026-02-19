import Toybox.WatchUi;

class settingsMenu extends WatchUi.Menu2{
    var settings = null;

    function initialize() {
        Menu2.initialize(null);
        Menu2.setTitle("Settings");

 		Menu2.addItem(new WatchUi.ToggleMenuItem("Leading Zero for Hours", null,"lz",true, null));
    }
}

class settingsMenuIterate extends WatchUi.Menu2InputDelegate{
    
}