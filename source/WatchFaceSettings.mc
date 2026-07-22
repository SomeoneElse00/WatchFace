import Toybox.WatchUi;

class settingsMenu extends WatchUi.Menu2{
    var settings = null;

    function initialize() {
        Menu2.initialize(null);
        Menu2.setTitle("Settings");

 		Menu2.addItem(new WatchUi.ToggleMenuItem("Leading Zero for Hours", null,"UseMilitaryFormat",true, null));
    }
}

class settingsMenuIterate extends WatchUi.Menu2InputDelegate{
    function initialize(){
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as MenuItem) as Void {
        var id = item.getId();
        switch (id) {
            case "UseMilitaryFormat":
                WatchUi.pushView(new boolMenu(id, "Leading Zero for Hours"),new boolMenuIterate(), WatchUi.SLIDE_LEFT);
                break;
            default:
                break;
        }
    }
}

class boolMenu extends WatchUi.Menu2{
    var boolmenu_id;

    function initialize(itemID, itemTitle){
        Menu2.initialize(null);
        Menu2.setTitle(itemTitle);
        boolmenu_id = itemID;

        var options = [
            { "title" => "Yes", "value" => true },
            { "title" => "No", "value" => false }
        ];

        for (var i = 0; i < options.size(); i++){
            var item = options[i];
            Menu2.addItem(new WatchUi.MenuItem(item["title"],null,item["value"],null));
        }
    }

    function getID(){
        return boolmenu_id;
    }
}

class boolMenuIterate extends WatchUi.Menu2InputDelegate{
    function initialize(){
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as MenuItem) {
        var menu = WatchUi.getCurrentView();

        if (menu instanceof boolMenu){
            Application.Properties.setValue(boolMenu.getID(), item.getValue());

            WatchUi.requestUpdate();

            WatchUi.popView(WatchUi.SLIDE_RIGHT);
        }
    }
}